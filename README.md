# OpenConstructionERP on Railway

[OpenConstructionERP](https://github.com/datadrivenconstruction/OpenConstructionERP) (AGPL-3.0) — an open-source construction ERP: bills of quantities (BOQ), BIM/CAD/PDF takeoff, 4D scheduling, 5D cost models, tendering, change orders and reporting, with a 70-project demo dataset. Deploy it on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/Gx5MMI)

## What this template runs

- **openconstructionerp**: `ghcr.io/onepush-dev/openconstructionerp:19.7.0`, the official `ghcr.io/datadrivenconstruction/openconstructionerp:19.7.0` image (unmodified) with Railway defaults and a small start wrapper. Public HTTPS domain on port 8080, healthcheck `/api/health`, volume at `/data` (uploads, vector index, generated files).
- **postgres**: `postgres:16-alpine` with a volume at `/var/lib/postgresql`, private network only.

## Variables

| Service | Variable | Value | Notes |
|---|---|---|---|
| openconstructionerp | `OE_OWNER_PASSWORD` | generated secret | Password of the owner/admin account `owner@example.com`, created at first boot. |
| openconstructionerp | `DEMO_USER_PASSWORD` | generated secret | Password of the demo admin `demo@openconstructionerp.com` (70 demo projects). |
| openconstructionerp | `DEMO_ESTIMATOR_PASSWORD` | generated secret | Demo estimator `estimator@openconstructionerp.com`. |
| openconstructionerp | `DEMO_MANAGER_PASSWORD` | generated secret | Demo manager `manager@openconstructionerp.com`. |
| openconstructionerp | `JWT_SECRET` | generated secret | Signs login tokens. |
| openconstructionerp | `ALLOWED_ORIGINS` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | CORS origin; add your custom domain here. |
| openconstructionerp | `OE_DB_HOST` | `${{postgres.RAILWAY_PRIVATE_DOMAIN}}` | Postgres host. |
| openconstructionerp | `OE_DB_PASSWORD` | `${{postgres.POSTGRES_PASSWORD}}` | Postgres password. |
| postgres | `POSTGRES_PASSWORD` | generated secret | Postgres superuser password. |

Baked into the image: `OE_DB_USER=postgres`, `OE_DB_NAME=postgres`, `OE_DB_PORT=5432`, `OE_DATA_DIR=/data`, `VECTOR_DATA_DIR=/data/vectors`, `APP_ENV=production`, `OE_OWNER_EMAIL=owner@example.com`.

## How to use

1. Deploy (first boot loads the demo data and takes a few minutes), then open the domain.
2. Sign in as `owner@example.com` with `OE_OWNER_PASSWORD`, or explore the demo projects as `demo@openconstructionerp.com` with `DEMO_USER_PASSWORD`.
3. Change the owner email in the profile settings. New self-registrations wait for admin approval (upstream default `admin-approve`).

## Notes

- Upstream hands admin to the first person who registers on a fresh install; the start wrapper claims that slot for the generated owner account so a stranger cannot.
- To remove the demo accounts set `DISABLE_DEMO_ACCOUNTS=1`.
- AI features (estimating assistant, classification) need your own LLM key, set in the app settings.
- Not affiliated with OpenConstructionERP / DataDrivenConstruction.
