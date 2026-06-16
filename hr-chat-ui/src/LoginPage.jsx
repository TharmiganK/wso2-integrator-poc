import { useAuthContext } from '@asgardeo/auth-react'
import './LoginPage.css'

export default function LoginPage() {
  const { signIn, state } = useAuthContext()

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-logo">🤝</div>
        <h1>HR Chat Assistant</h1>
        <p>Sign in to access HR policies, leave, payroll&nbsp;&amp;&nbsp;more</p>
        <button
          className="btn-signin"
          onClick={() => signIn()}
          disabled={state.isLoading}
        >
          {state.isLoading ? 'Redirecting…' : 'Sign in with WSO2'}
        </button>
      </div>
    </div>
  )
}
