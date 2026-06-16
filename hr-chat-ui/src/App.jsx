import { useState, useEffect, useRef, useCallback } from 'react'
import { useAuthContext } from '@asgardeo/auth-react'
import LoginPage from './LoginPage.jsx'
import './App.css'

function generateSessionId() {
  return 'sess-' + Date.now().toString(36) + '-' + Math.random().toString(36).slice(2, 8)
}

function formatTime(date) {
  return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
}

function Message({ role, text, time }) {
  return (
    <div className={`message ${role}`}>
      <div className="bubble">{text}</div>
      {time && <div className="timestamp">{time}</div>}
    </div>
  )
}

function TypingIndicator() {
  return (
    <div className="message bot typing">
      <div className="bubble">
        <span className="dot" />
        <span className="dot" />
        <span className="dot" />
      </div>
    </div>
  )
}

export default function App() {
  const { state, signOut, getBasicUserInfo } = useAuthContext()
  const [userInfo, setUserInfo] = useState(null)

  const [sessionId, setSessionId] = useState(generateSessionId)
  const [messages, setMessages] = useState([
    { id: 0, role: 'system', text: "👋 Hello! I'm your HR assistant. Ask me about leave policies, payroll, benefits, or anything HR-related." },
  ])
  const [input, setInput] = useState('')
  const [isWaiting, setIsWaiting] = useState(false)
  const [error, setError] = useState(null)

  const messagesEndRef = useRef(null)
  const textareaRef = useRef(null)
  const nextId = useRef(1)

  useEffect(() => {
    if (state.isAuthenticated) {
      getBasicUserInfo().then(setUserInfo).catch(console.error)
    }
  }, [state.isAuthenticated])

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages, isWaiting])

  const newSession = useCallback(() => {
    setSessionId(generateSessionId())
    setMessages([{ id: 0, role: 'system', text: 'New session started. How can I help you?' }])
    setError(null)
    textareaRef.current?.focus()
  }, [])

  const sendMessage = useCallback(async () => {
    const text = input.trim()
    if (!text || isWaiting) return

    const username = userInfo?.username
    if (!username) {
      setError('Session expired. Please sign in again.')
      return
    }

    setInput('')
    setError(null)
    setIsWaiting(true)

    setMessages(prev => [...prev, {
      id: nextId.current++,
      role: 'user',
      text,
      time: formatTime(new Date()),
    }])

    try {
      const res = await fetch('/chatAssistant/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'User': username,
        },
        body: JSON.stringify({ sessionId, message: text }),
      })

      if (!res.ok) {
        const err = await res.json().catch(() => ({}))
        throw new Error(`${res.status}: ${err.message || res.statusText}`)
      }

      const data = await res.json()
      setMessages(prev => [...prev, {
        id: nextId.current++,
        role: 'bot',
        text: data.message || '(no response)',
        time: formatTime(new Date()),
      }])
    } catch (e) {
      setError(e.message)
      setMessages(prev => [...prev, {
        id: nextId.current++,
        role: 'bot',
        text: 'Sorry, something went wrong. Please try again.',
        time: formatTime(new Date()),
      }])
    } finally {
      setIsWaiting(false)
      textareaRef.current?.focus()
    }
  }, [input, isWaiting, sessionId, userInfo])

  const onKeyDown = useCallback((e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      sendMessage()
    }
  }, [sendMessage])

  // SDK is checking stored session or handling OIDC callback
  if (state.isLoading) {
    return <div className="auth-loading"><div className="auth-spinner" /></div>
  }

  if (!state.isAuthenticated) {
    return <LoginPage />
  }

  const displayName = userInfo?.displayName || userInfo?.username || 'User'
  const initial = displayName.charAt(0).toUpperCase()

  return (
    <div className="chat-container">
      <div className="header">
        <div className="header-avatar user-initial">{initial}</div>
        <div className="header-info">
          <h1>HR Chat Assistant</h1>
          <p>Signed in as {displayName}</p>
        </div>
        <div className="header-actions">
          <button className="btn-new-session" onClick={newSession}>New Session</button>
          <button className="btn-sign-out" onClick={() => signOut()}>Sign Out</button>
        </div>
      </div>

      <div className="messages">
        {messages.map(m => (
          <Message key={m.id} role={m.role} text={m.text} time={m.time} />
        ))}
        {isWaiting && <TypingIndicator />}
        <div ref={messagesEndRef} />
      </div>

      {error && <div className="error-banner">Error: {error}</div>}

      <div className="input-area">
        <textarea
          ref={textareaRef}
          className="message-input"
          rows={1}
          placeholder="Type your question…"
          value={input}
          onChange={e => setInput(e.target.value)}
          onKeyDown={onKeyDown}
          autoFocus
        />
        <button
          className="send-btn"
          onClick={sendMessage}
          disabled={isWaiting || !input.trim()}
          title="Send"
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
            <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" />
          </svg>
        </button>
      </div>
    </div>
  )
}
