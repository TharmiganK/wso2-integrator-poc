# HR Chat UI

## Overview

A React single-page application that provides a browser-based chat interface for the [HR Chat Assistant](../hr_chat_assistant/README.md) integration. Employees log in with their organisational identity via **WSO2 Identity Server** and interact with the AI-powered HR assistant to query policies, leave balances, payslips, and more.

The app proxies all `/chatAssistant` API calls to the HR Chat Assistant integration running on `localhost:9090`.

## Prerequisites

- Node.js 18+ and npm
- A running **WSO2 Identity Server** instance (or Asgardeo) with an application configured for this client
- The **HR Chat Assistant** integration running on port `9090`

## Configuration

Copy `.env.local` and fill in the values for your environment:

| Variable | Description | Example |
|---|---|---|
| `VITE_AUTH_CLIENT_ID` | Client ID of the application registered in WSO2 IS / Asgardeo | `WSCYhNxp7gn0hH6Q_5X5wqfLklMa` |
| `VITE_AUTH_BASE_URL` | Base URL of the WSO2 IS / Asgardeo instance | `https://localhost:9443` |
| `VITE_SIGN_IN_REDIRECT_URL` | URL the browser is redirected to after login | `http://localhost:5173` |
| `VITE_SIGN_OUT_REDIRECT_URL` | URL the browser is redirected to after logout | `http://localhost:5173` |

## Running

### Install dependencies

```bash
npm install
```

### Start development server

```bash
npm run dev
```

The app is available at `http://localhost:5173`.

### Build for production

```bash
npm run build
```

The production-ready files are output to `dist/`.

### Preview production build locally

```bash
npm run preview
```
