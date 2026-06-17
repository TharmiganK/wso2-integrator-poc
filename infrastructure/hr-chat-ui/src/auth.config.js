const authConfig = {
  clientID: import.meta.env.VITE_AUTH_CLIENT_ID,
  baseUrl: import.meta.env.VITE_AUTH_BASE_URL,
  signInRedirectURL: import.meta.env.VITE_SIGN_IN_REDIRECT_URL ?? window.location.origin,
  signOutRedirectURL: import.meta.env.VITE_SIGN_OUT_REDIRECT_URL ?? window.location.origin,
  scope: ['openid', 'profile', 'email'],
}

export default authConfig
