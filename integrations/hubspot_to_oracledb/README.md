# HubSpot to Oracle DB

## Overview

The HubSpot to Oracle DB integration listens for contact lifecycle events from **HubSpot** via webhooks and keeps an **Oracle Database** table (`HUBSPOT_CONTACTS`) in sync. It handles contact creation, deletion, and property changes in real time.

## Events Handled

| HubSpot Event | Action on Oracle DB |
|---|---|
| Contact created | `INSERT` into `HUBSPOT_CONTACTS` |
| Contact deleted | `DELETE` from `HUBSPOT_CONTACTS` |
| Contact property changed (`email`, `firstname`, `lastname`, `phone`) | `UPDATE` the corresponding column |
| Contact association changed | No-op (logged) |
| Contact merged | No-op (logged) |
| Contact restored | No-op (logged) |
| Contact privacy deletion | No-op (logged) |

The webhook listener runs on port **8090**.

## Prerequisites

- A **HubSpot** account with:
  - A private app token (for API access)
  - A webhook subscription configured to point to this integration's callback URL
  - An OAuth app client secret (for webhook signature verification)
- An **Oracle Database** instance with the `HUBSPOT_CONTACTS` table provisioned
- A publicly accessible callback URL (e.g., via ngrok or a cloud deployment) for HubSpot to deliver webhook events

## Configuration

Open `Config.toml` and provide the following values:

### HubSpot

| Key | Description | Example |
|---|---|---|
| `hubspotToken` | HubSpot private app access token | `pat-na2-...` |
| `clientSecret` | HubSpot OAuth app client secret (used for webhook verification) | `a7605af8-...` |
| `callbackURL` | Publicly accessible URL that HubSpot delivers webhook events to | `https://your-domain.ngrok-free.dev` |

### Oracle Database

| Key | Description | Example |
|---|---|---|
| `oracleDbHost` | Hostname of the Oracle DB instance | `localhost` |
| `oracleDbPort` | Port of the Oracle DB instance | `1521` |
| `oracleDbName` | Oracle DB service name or PDB name | `FREEPDB1` |
| `oracleDbUser` | Oracle DB username | `hr_user` |
| `oracleDbPassword` | Oracle DB password | `••••••••` |

**Example `Config.toml`:**
```toml
[tharmigank.hubspot_to_oracledb]
hubspotToken = "<hubspot private app token>"
clientSecret = "<oauth client secret>"
callbackURL = "https://<your-public-url>"
oracleDbHost = "localhost"
oracleDbPort = 1521
oracleDbName = "FREEPDB1"
oracleDbUser = "<db username>"
oracleDbPassword = "<db password>"
```

## Exposing the Webhook Port with ngrok

HubSpot requires a publicly accessible URL to deliver webhook events. When running locally, use **ngrok** to expose port `8090`:

1. Install ngrok from [ngrok.com](https://ngrok.com) and authenticate:

   ```bash
   ngrok config add-authtoken <your-auth-token>
   ```

2. Start a tunnel on port `8090`:

   ```bash
   ngrok http 8090
   ```

3. Copy the forwarding URL from the ngrok output (e.g. `https://abc123.ngrok-free.app`) and set it as the `callbackURL` in `Config.toml`:

   ```toml
   callbackURL = "https://abc123.ngrok-free.app"
   ```

4. Register the same URL as the webhook endpoint in your HubSpot app settings.

> **Note:** The ngrok URL changes every time you restart the tunnel (on the free plan). Update `callbackURL` and the HubSpot webhook subscription each time you get a new URL, or use a [static domain](https://ngrok.com/docs/getting-started/#step-4-secure-your-app) if available on your plan.

## Running the Integration

1. Ensure the Oracle Database is running and the `HUBSPOT_CONTACTS` table exists
2. Start the ngrok tunnel on port `8090` and update `callbackURL` in `Config.toml`
3. Open the `hubspot_to_oracledb` folder in **WSO2 Integrator**
4. Edit `Config.toml` and fill in all required values
5. Click **Run** in the WSO2 Integrator toolbar
6. The webhook listener starts on port `8090` and begins processing HubSpot events
