# Supabase CLI v1 Configuration

The specification is divided into two main sections:
1. **Info**: General information about the tool.
2. **Parameters**: Configurable parameters available to the user.

## Info

- **Id**: cli
- **Version**: 1.93.0
- **Title**: CLI
- **Source**: https://github.com/supabase/cli
- **Bugs**: https://github.com/supabase/cli/issues
- **Spec**: https://github.com/supabase/supabase/spec/cli_v1_config.yaml
- **Description**: A `supabase/config.toml` file is generated after running `supabase init`.

You can edit this file to change the settings for your locally running project. After you make changes, you will need to restart using `supabase stop` and then `supabase start` for the changes to take effect.

- **Tags**:
  - **general** (General): General settings.
  - **auth** (Auth): Auth settings.
  - **api** (API): Auth settings.
  - **database** (Database): Database settings.
  - **dashboard** (Dashboard): Dashboard settings.
  - **realtime** (Realtime): Dashboard settings.
  - **storage** (Storage): Storage settings.
  - **edge-functions** (Edge-Functions): Edge-Functions settings.
  - **analytics** (Analytics): Analytics settings.
  - **experimental** (Experimental): Settings in alpha testing, subject to changes or removal at any time.
  - **local** (Local Development): Local Development settings.

## Parameters

### project_id
- **Title**: project_id
- **Tags**: general
- **Required**: True
- **Description**:
  A string used to distinguish different Supabase projects on the same host. Defaults to the working directory name when running `supabase init`.

### api.enabled
- **Title**: api.enabled
- **Tags**: api
- **Required**: False
- **Default**: true
- **Description**:
  Enable the local PostgREST service.
- **Links**:
  - [PostgREST configuration](https://postgrest.org/en/stable/configuration.html)

### api.port
- **Title**: api.port
- **Tags**: api
- **Required**: False
- **Default**: 54321
- **Description**:
  Port to use for the API URL.
- **Links**:
  - [PostgREST configuration](https://postgrest.org/en/stable/configuration.html)
- **Usage**:
```
[api]
port = 54321
```

### api.schemas
- **Title**: api.schemas
- **Tags**: api
- **Required**: False
- **Default**: ["public", "storage", "graphql_public"]
- **Description**:
  Schemas to expose in your API. Tables, views and functions in this schema will get API endpoints. `public` and `storage` are always included.
- **Links**:
  - [PostgREST configuration](https://postgrest.org/en/stable/configuration.html)

### api.extra_search_path
- **Title**: api.extra_search_path
- **Tags**: api
- **Required**: False
- **Default**: ["public", "extensions"]
- **Description**:
  Extra schemas to add to the search_path of every request. public is always included.
- **Links**:
  - [PostgREST configuration](https://postgrest.org/en/stable/configuration.html)

### api.max_rows
- **Title**: api.max_rows
- **Tags**: api
- **Required**: False
- **Default**: 1000
- **Description**:
  The maximum number of rows returned from a view, table, or stored procedure. Limits payload size for accidental or malicious requests.
- **Links**:
  - [PostgREST configuration](https://postgrest.org/en/stable/configuration.html)

### db.port
- **Title**: db.port
- **Tags**: database
- **Required**: False
- **Default**: 54322
- **Description**:
  Port to use for the local database URL.
- **Links**:
  - [PostgreSQL configuration](https://postgrest.org/en/stable/configuration.html)

### db.shadow_port
- **Title**: db.shadow_port
- **Tags**: database
- **Required**: False
- **Default**: 54320
- **Description**:
  Port to use for the local shadow database.
- **Links**:

### db.major_version
- **Title**: db.major_version
- **Tags**: database
- **Required**: False
- **Default**: 15
- **Description**:
  The database major version to use. This has to be the same as your remote database's. Run `SHOW server_version;` on the remote database to check.
- **Links**:
  - [PostgreSQL configuration](https://postgrest.org/en/stable/configuration.html)

### db.pooler.enabled
- **Title**: db.pooler.enabled
- **Tags**: database
- **Required**: False
- **Default**: false
- **Description**:
  Enable the local PgBouncer service.
- **Links**:
  - [PgBouncer Configuration](https://www.pgbouncer.org/config.html)

### db.pooler.port
- **Title**: db.pooler.port
- **Tags**: database
- **Required**: False
- **Default**: 54329
- **Description**:
  Port to use for the local connection pooler.
- **Links**:
  - [PgBouncer Configuration](https://www.pgbouncer.org/config.html#listen_port)

### db.pooler.pool_mode
- **Title**: db.pooler.pool_mode
- **Tags**: database
- **Required**: False
- **Default**: "transaction"
- **Description**:
  Specifies when a server connection can be reused by other clients. Configure one of the supported pooler modes: `transaction`, `session`.
- **Links**:
  - [PgBouncer Configuration](https://www.pgbouncer.org/config.html#pool_mode)

### db.pooler.default_pool_size
- **Title**: db.pooler.default_pool_size
- **Tags**: database
- **Required**: False
- **Default**: 20
- **Description**:
  How many server connections to allow per user/database pair.
- **Links**:
  - [PgBouncer Configuration](https://www.pgbouncer.org/config.html#default_pool_size)

### db.settings.effective_cache_size
- **Title**: db.settings.effective_cache_size
- **Tags**: database
- **Required**: False
- **Description**:
  Sets the planner's assumption about the effective size of the disk cache.
This is a query planner parameter that doesn't affect actual memory allocation.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-query.html#GUC-EFFECTIVE-CACHE-SIZE)

### db.settings.logical_decoding_work_mem
- **Title**: db.settings.logical_decoding_work_mem
- **Tags**: database
- **Required**: False
- **Description**:
  Specifies the amount of memory to be used by logical decoding, before writing data to local disk.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-LOGICAL-DECODING-WORK-MEM)

### db.settings.maintenance_work_mem
- **Title**: db.settings.maintenance_work_mem
- **Tags**: database
- **Required**: False
- **Description**:
  Specifies the maximum amount of memory to be used by maintenance operations, such as VACUUM, CREATE INDEX, and ALTER TABLE ADD FOREIGN KEY.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-MAINTENANCE-WORK-MEM)

### db.settings.max_connections
- **Title**: db.settings.max_connections
- **Tags**: database
- **Required**: False
- **Description**:
  Determines the maximum number of concurrent connections to the database server.
Note: Changing this parameter requires a database restart.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-connection.html#GUC-MAX-CONNECTIONS)

### db.settings.max_locks_per_transaction
- **Title**: db.settings.max_locks_per_transaction
- **Tags**: database
- **Required**: False
- **Description**:
  Controls the average number of object locks allocated for each transaction.
Note: Changing this parameter requires a database restart.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-locks.html#GUC-MAX-LOCKS-PER-TRANSACTION)

### db.settings.max_parallel_maintenance_workers
- **Title**: db.settings.max_parallel_maintenance_workers
- **Tags**: database
- **Required**: False
- **Description**:
  Sets the maximum number of parallel workers that can be started by a single utility command.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-MAX-PARALLEL-MAINTENANCE-WORKERS)

### db.settings.max_parallel_workers
- **Title**: db.settings.max_parallel_workers
- **Tags**: database
- **Required**: False
- **Description**:
  Sets the maximum number of parallel workers that the system can support.
Note: Changing this parameter requires a database restart.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-MAX-PARALLEL-WORKERS)

### db.settings.max_parallel_workers_per_gather
- **Title**: db.settings.max_parallel_workers_per_gather
- **Tags**: database
- **Required**: False
- **Description**:
  Sets the maximum number of parallel workers that can be started by a single Gather or Gather Merge node.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-MAX-PARALLEL-WORKERS-PER-GATHER)

### db.settings.max_replication_slots
- **Title**: db.settings.max_replication_slots
- **Tags**: database
- **Required**: False
- **Description**:
  Specifies the maximum number of replication slots that the server can support.
Note: Changing this parameter requires a database restart.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-replication.html#GUC-MAX-REPLICATION-SLOTS)

### db.settings.max_slot_wal_keep_size
- **Title**: db.settings.max_slot_wal_keep_size
- **Tags**: database
- **Required**: False
- **Description**:
  Specifies the maximum size of WAL files that replication slots are allowed to retain in the pg_wal directory.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-replication.html#GUC-MAX-SLOT-WAL-KEEP-SIZE)

### db.settings.max_standby_archive_delay
- **Title**: db.settings.max_standby_archive_delay
- **Tags**: database
- **Required**: False
- **Description**:
  Sets the maximum delay before canceling queries when a hot standby server is processing archived WAL data.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-replication.html#GUC-MAX-STANDBY-ARCHIVE-DELAY)

### db.settings.max_standby_streaming_delay
- **Title**: db.settings.max_standby_streaming_delay
- **Tags**: database
- **Required**: False
- **Description**:
  Sets the maximum delay before canceling queries when a hot standby server is processing streamed WAL data.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-replication.html#GUC-MAX-STANDBY-STREAMING-DELAY)

### db.settings.max_wal_size
- **Title**: db.settings.max_wal_size
- **Tags**: database
- **Required**: False
- **Description**:
  Sets the maximum size of WAL files that the system will keep in the pg_wal directory.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-wal.html#GUC-MAX-WAL-SIZE)

### db.settings.max_wal_senders
- **Title**: db.settings.max_wal_senders
- **Tags**: database
- **Required**: False
- **Description**:
  Specifies the maximum number of concurrent connections from standby servers or streaming base backup clients.
Note: Changing this parameter requires a database restart.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-replication.html#GUC-MAX-WAL-SENDERS)

### db.settings.max_worker_processes
- **Title**: db.settings.max_worker_processes
- **Tags**: database
- **Required**: False
- **Description**:
  Sets the maximum number of background processes that the system can support.
Note: Changing this parameter requires a database restart.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES)

### db.settings.session_replication_role
- **Title**: db.settings.session_replication_role
- **Tags**: database
- **Required**: False
- **Description**:
  Controls whether triggers and rewrite rules are enabled. Valid values are: "origin", "replica", or "local".
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-client.html#GUC-SESSION-REPLICATION-ROLE)

### db.settings.shared_buffers
- **Title**: db.settings.shared_buffers
- **Tags**: database
- **Required**: False
- **Description**:
  Sets the amount of memory the database server uses for shared memory buffers.
Note: Changing this parameter requires a database restart.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-SHARED-BUFFERS)

### db.settings.statement_timeout
- **Title**: db.settings.statement_timeout
- **Tags**: database
- **Required**: False
- **Description**:
  Abort any statement that takes more than the specified amount of time.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-client.html#GUC-STATEMENT-TIMEOUT)

### db.settings.track_commit_timestamp
- **Title**: db.settings.track_commit_timestamp
- **Tags**: database
- **Required**: False
- **Description**:
  Record commit time of transactions.
Note: Changing this parameter requires a database restart.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-replication.html#GUC-TRACK-COMMIT-TIMESTAMP)

### db.settings.wal_keep_size
- **Title**: db.settings.wal_keep_size
- **Tags**: database
- **Required**: False
- **Description**:
  Specifies the minimum size of past log file segments kept in the pg_wal directory.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-replication.html#GUC-WAL-KEEP-SIZE)

### db.settings.wal_sender_timeout
- **Title**: db.settings.wal_sender_timeout
- **Tags**: database
- **Required**: False
- **Description**:
  Terminate replication connections that are inactive for longer than this amount of time.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-replication.html#GUC-WAL-SENDER-TIMEOUT)

### db.settings.work_mem
- **Title**: db.settings.work_mem
- **Tags**: database
- **Required**: False
- **Description**:
  Specifies the amount of memory to be used by internal sort operations and hash tables before writing to temporary disk files.
- **Links**:
  - [PostgreSQL configuration](https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-WORK-MEM)

### db.pooler.max_client_conn
- **Title**: db.pooler.max_client_conn
- **Tags**: database
- **Required**: False
- **Default**: 100
- **Description**:
  Maximum number of client connections allowed.
- **Links**:
  - [PgBouncer Configuration](https://www.pgbouncer.org/config.html#max_client_conn)

### db.seed.enabled
- **Title**: db.seed.enabled
- **Tags**: database
- **Required**: False
- **Default**: true
- **Description**:
  Enables running seeds when starting or resetting the database.
- **Links**:

### db.seed.sql_paths
- **Title**: db.seed.sql_paths
- **Tags**: database
- **Required**: False
- **Default**: ["./seed.sql"]
- **Description**:
  An array of files or glob patterns to find seeds in.
- **Links**:
  - [Seeding your database](https://supabase.com/docs/guides/cli/seeding-your-database)

### realtime.enabled
- **Title**: realtime.enabled
- **Tags**: realtime
- **Required**: False
- **Default**: true
- **Description**:
  Enable the local Realtime service.
- **Links**:

### realtime.ip_version
- **Title**: realtime.ip_version
- **Tags**: realtime
- **Required**: False
- **Default**: "IPv6"
- **Description**:
  Bind realtime via either IPv4 or IPv6. (default: IPv6)
- **Links**:

### studio.enabled
- **Title**: studio.enabled
- **Tags**: dashboard
- **Required**: False
- **Default**: true
- **Description**:
  Enable the local Supabase Studio dashboard.
- **Links**:

### studio.port
- **Title**: studio.port
- **Tags**: dashboard
- **Required**: False
- **Default**: 54323
- **Description**:
  Port to use for Supabase Studio.
- **Links**:

### studio.api_url
- **Title**: studio.api_url
- **Tags**: dashboard
- **Required**: False
- **Default**: "http://localhost"
- **Description**:
  External URL of the API server that frontend connects to.
- **Links**:

### inbucket.enabled
- **Title**: inbucket.enabled
- **Tags**: local
- **Required**: False
- **Default**: true
- **Description**:
  Enable the local InBucket service.
- **Links**:
  - [Inbucket documentation](https://www.inbucket.org)

### inbucket.port
- **Title**: inbucket.port
- **Tags**: local
- **Required**: False
- **Default**: 54324
- **Description**:
  Port to use for the email testing server web interface.

Emails sent with the local dev setup are not actually sent - rather, they are monitored, and you can view the emails that would have been sent from the web interface.
- **Links**:
  - [Inbucket documentation](https://www.inbucket.org)

### inbucket.smtp_port
- **Title**: inbucket.smtp_port
- **Tags**: local
- **Required**: False
- **Default**: 54325
- **Description**:
  Port to use for the email testing server SMTP port.

Emails sent with the local dev setup are not actually sent - rather, they are monitored, and you can view the emails that would have been sent from the web interface.

If set, you can access the SMTP server from this port.
- **Links**:
  - [Inbucket documentation](https://www.inbucket.org)

### inbucket.pop3_port
- **Title**: inbucket.pop3_port
- **Tags**: local
- **Required**: False
- **Default**: 54326
- **Description**:
  Port to use for the email testing server POP3 port.

Emails sent with the local dev setup are not actually sent - rather, they are monitored, and you can view the emails that would have been sent from the web interface.

If set, you can access the POP3 server from this port.
- **Links**:
  - [Inbucket documentation](https://www.inbucket.org)

### inbucket.admin_email
- **Title**: inbucket.admin_email
- **Tags**: local
- **Required**: False
- **Default**: admin@email.com
- **Description**:
  Email used as the sender for emails sent from the application.

### inbucket.sender_name
- **Title**: inbucket.sender_name
- **Tags**: local
- **Required**: False
- **Default**: Admin
- **Description**:
  Display name used as the sender for emails sent from the application.

### storage.enabled
- **Title**: storage.enabled
- **Tags**: storage
- **Required**: False
- **Default**: true
- **Description**:
  Enable the local Storage service.
- **Links**:
  - [Storage server configuration](https://supabase.com/docs/guides/self-hosting/storage/config)

### storage.file_size_limit
- **Title**: storage.file_size_limit
- **Tags**: storage
- **Required**: False
- **Default**: "50MiB"
- **Description**:
  The maximum file size allowed for all buckets in the project.
- **Links**:
  - [Storage server configuration](https://supabase.com/docs/guides/self-hosting/storage/config)

### storage.buckets.bucket_name.public
- **Title**: storage.buckets.<bucket_name>.public
- **Tags**: storage
- **Required**: False
- **Default**: false
- **Description**:
  Enable public access to the bucket.
- **Links**:
  - [Storage server configuration](https://supabase.com/docs/guides/self-hosting/storage/config)

### storage.buckets.bucket_name.file_size_limit
- **Title**: storage.buckets.<bucket_name>.file_size_limit
- **Tags**: storage
- **Required**: False
- **Description**:
  The maximum file size allowed (e.g. "5MB", "500KB").
- **Links**:
  - [Storage server configuration](https://supabase.com/docs/guides/self-hosting/storage/config)

### storage.buckets.bucket_name.allowed_mime_types
- **Title**: storage.buckets.<bucket_name>.allowed_mime_types
- **Tags**: storage
- **Required**: False
- **Description**:
  The list of allowed MIME types for objects in the bucket.
- **Links**:
  - [Storage server configuration](https://supabase.com/docs/guides/self-hosting/storage/config)

### storage.buckets.bucket_name.objects_path
- **Title**: storage.buckets.<bucket_name>.objects_path
- **Tags**: storage
- **Required**: False
- **Description**:
  The local directory to upload objects to the bucket.
- **Links**:
  - [Storage server configuration](https://supabase.com/docs/guides/self-hosting/storage/config)

### auth.enabled
- **Title**: auth.enabled
- **Tags**: auth
- **Required**: False
- **Default**: true
- **Description**:
  Enable the local GoTrue service.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.site_url
- **Title**: auth.site_url
- **Tags**: auth
- **Required**: False
- **Default**: "http://localhost:3000"
- **Description**:
  The base URL of your website. Used as an allow-list for redirects and for constructing URLs used in emails.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.additional_redirect_urls
- **Title**: auth.additional_redirect_urls
- **Tags**: auth
- **Required**: False
- **Default**: ["https://localhost:3000"]
- **Description**:
  A list of _exact_ URLs that auth providers are permitted to redirect to post authentication.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.jwt_expiry
- **Title**: auth.jwt_expiry
- **Tags**: auth
- **Required**: False
- **Default**: 3600
- **Description**:
  How long tokens are valid for, in seconds. Defaults to 3600 (1 hour), maximum 604,800 seconds (one week).
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.enable_manual_linking
- **Title**: auth.enable_manual_linking
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Allow testing manual linking of accounts
- **Links**:
  - [Anonymous Sign Ins (Manual Linking)](https://supabase.com/docs/guides/auth/auth-anonymous?queryGroups=language&language=python#convert-an-anonymous-user-to-a-permanent-user)

### auth.enable_refresh_token_rotation
- **Title**: auth.enable_refresh_token_rotation
- **Tags**: auth
- **Required**: False
- **Default**: true
- **Description**:
  If disabled, the refresh token will never expire.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.refresh_token_reuse_interval
- **Title**: auth.refresh_token_reuse_interval
- **Tags**: auth
- **Required**: False
- **Default**: 10
- **Description**:
  Allows refresh tokens to be reused after expiry, up to the specified interval in seconds. Requires enable_refresh_token_rotation = true.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.enable_signup
- **Title**: auth.enable_signup
- **Tags**: auth
- **Required**: False
- **Default**: true
- **Description**:
  Allow/disallow new user signups to your project.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.enable_anonymous_sign_ins
- **Title**: auth.enable_anonymous_sign_ins
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Allow/disallow anonymous sign-ins to your project.
- **Links**:
  - [Anonymous Sign Ins](https://supabase.com/docs/guides/auth/auth-anonymous)

### auth.email.enable_signup
- **Title**: auth.email.enable_signup
- **Tags**: auth
- **Required**: False
- **Default**: true
- **Description**:
  Allow/disallow new user signups via email to your project.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.email.double_confirm_changes
- **Title**: auth.email.double_confirm_changes
- **Tags**: auth
- **Required**: False
- **Default**: true
- **Description**:
  If enabled, a user will be required to confirm any email change on both the old, and new email addresses. If disabled, only the new email is required to confirm.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.email.enable_confirmations
- **Title**: auth.email.enable_confirmations
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  If enabled, users need to confirm their email address before signing in.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.email.secure_password_change
- **Title**: auth.email.secure_password_change
- **Tags**: auth
- **Required**: False
- **Default**: False
- **Description**:
  If enabled, requires the user's current password to be provided when changing to a new password.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.email.max_frequency
- **Title**: auth.email.max_frequency
- **Tags**: auth
- **Required**: False
- **Default**: 1m
- **Description**:
  The minimum amount of time that must pass between email requests.
Helps prevent email spam by limiting how frequently emails can be sent.
Example values: "1m", "1h", "24h"
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.email.otp_length
- **Title**: auth.email.otp_length
- **Tags**: auth
- **Required**: False
- **Default**: 6
- **Description**:
  The length of the OTP code to be sent in emails.
Must be between 6 and 10 digits.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.email.otp_exp
- **Title**: auth.email.otp_exp
- **Tags**: auth
- **Required**: False
- **Default**: 300
- **Description**:
  The expiry time for an OTP code in seconds.
Default is 300 seconds (5 minutes).
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.email.smtp.host
- **Title**: auth.email.smtp.host
- **Tags**: auth
- **Required**: False
- **Default**: inbucket
- **Description**:
  Hostname or IP address of the SMTP server.

### auth.email.smtp.port
- **Title**: auth.email.smtp.port
- **Tags**: auth
- **Required**: False
- **Default**: 2500
- **Description**:
  Port number of the SMTP server.

### auth.email.smtp.user
- **Title**: auth.email.smtp.user
- **Tags**: auth
- **Required**: False
- **Description**:
  Username for authenticating with the SMTP server.

### auth.email.smtp.pass
- **Title**: auth.email.smtp.pass
- **Tags**: auth
- **Required**: False
- **Description**:
  Password for authenticating with the SMTP server.

### auth.email.smtp.admin_email
- **Title**: auth.email.smtp.admin_email
- **Tags**: auth
- **Required**: False
- **Default**: admin@email.com
- **Description**:
  Email used as the sender for emails sent from the application.

### auth.email.smtp.sender_name
- **Title**: auth.email.smtp.sender_name
- **Tags**: auth
- **Required**: False
- **Description**:
  Display name used as the sender for emails sent from the application.

### auth.email.template.type.subject
- **Title**: auth.email.template.<type>.subject
- **Tags**: auth
- **Required**: False
- **Description**:
  The full list of email template types are:

- `invite`
- `confirmation`
- `recovery`
- `magic_link`
- `email_change`
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.email.template.type.content_path
- **Title**: auth.email.template.<type>.content_path
- **Tags**: auth
- **Required**: False
- **Description**:
  The full list of email template types are:

- `invite`
- `confirmation`
- `recovery`
- `magic_link`
- `email_change`
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.enable_signup
- **Title**: auth.sms.enable_signup
- **Tags**: auth
- **Required**: False
- **Default**: true
- **Description**:
  Allow/disallow new user signups via SMS to your project.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.enable_confirmations
- **Title**: auth.sms.enable_confirmations
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  If enabled, users need to confirm their phone number before signing in.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.test_otp
- **Title**: auth.sms.test_otp
- **Tags**: auth
- **Required**: False
- **Description**:
  Use pre-defined map of phone number to OTP for testing.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)
- **Usage**:
```
[auth.sms.test_otp]
4152127777 = "123456"
```

### auth.sms.provider.enabled
- **Title**: auth.sms.<provider>.enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Use an external SMS provider. The full list of providers are:

- `twilio`
- `twilio_verify`
- `messagebird`
- `textlocal`
- `vonage`
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.twilio.account_sid
- **Title**: auth.sms.<twilio|twilio_verify>.account_sid
- **Tags**: auth
- **Required**: True
- **Description**:
  Twilio Account SID
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.twilio.message_service_sid
- **Title**: auth.sms.<twilio|twilio_verify>.message_service_sid
- **Tags**: auth
- **Required**: True
- **Description**:
  Twilio Message Service SID
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.twilio.auth_token
- **Title**: auth.sms.<twilio|twilio_verify>.auth_token
- **Tags**: auth
- **Required**: True
- **Default**: env(SUPABASE_AUTH_SMS_TWILIO_AUTH_TOKEN)
- **Description**:
  Twilio Auth Token

DO NOT commit your Twilio auth token to git. Use environment variable substitution instead.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.messagebird.originator
- **Title**: auth.sms.messagebird.originator
- **Tags**: auth
- **Required**: True
- **Description**:
  MessageBird Originator
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.messagebird.access_key
- **Title**: auth.sms.messagebird.access_key
- **Tags**: auth
- **Required**: True
- **Default**: env(SUPABASE_AUTH_SMS_MESSAGEBIRD_ACCESS_KEY)
- **Description**:
  MessageBird Access Key

DO NOT commit your MessageBird access key to git. Use environment variable substitution instead.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.textlocal.sender
- **Title**: auth.sms.textlocal.sender
- **Tags**: auth
- **Required**: True
- **Description**:
  TextLocal Sender
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.textlocal.api_key
- **Title**: auth.sms.textlocal.api_key
- **Tags**: auth
- **Required**: True
- **Default**: env(SUPABASE_AUTH_SMS_TEXTLOCAL_API_KEY)
- **Description**:
  TextLocal API Key

DO NOT commit your TextLocal API key to git. Use environment variable substitution instead.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.vonage.from
- **Title**: auth.sms.vonage.from
- **Tags**: auth
- **Required**: True
- **Description**:
  Vonage From
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.vonage.api_key
- **Title**: auth.sms.vonage.api_key
- **Tags**: auth
- **Required**: True
- **Description**:
  Vonage API Key
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.sms.vonage.api_secret
- **Title**: auth.sms.vonage.api_secret
- **Tags**: auth
- **Required**: True
- **Default**: env(SUPABASE_AUTH_SMS_VONAGE_API_SECRET)
- **Description**:
  Vonage API Secret

DO NOT commit your Vonage API secret to git. Use environment variable substitution instead.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.external.provider.enabled
- **Title**: auth.external.<provider>.enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Use an external OAuth provider. The full list of providers are:

- `apple`
- `azure`
- `bitbucket`
- `discord`
- `facebook`
- `github`
- `gitlab`
- `google`
- `kakao`
- `keycloak`
- `linkedin_oidc`
- `notion`
- `twitch`
- `twitter`
- `slack_oidc`
- `spotify`
- `workos`
- `zoom`
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.external.provider.client_id
- **Title**: auth.external.<provider>.client_id
- **Tags**: auth
- **Required**: True
- **Description**:
  Client ID for the external OAuth provider.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.external.provider.secret
- **Title**: auth.external.<provider>.secret
- **Tags**: auth
- **Required**: True
- **Default**: env(SUPABASE_AUTH_EXTERNAL_<PROVIDER>_SECRET)
- **Description**:
  Client secret for the external OAuth provider.

DO NOT commit your OAuth provider secret to git. Use environment variable substitution instead.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.external.provider.url
- **Title**: auth.external.<provider>.url
- **Tags**: auth
- **Required**: False
- **Description**:
  The base URL used for constructing the URLs to request authorization and
access tokens. Used by gitlab and keycloak. For gitlab it defaults to
https://gitlab.com. For keycloak you need to set this to your instance,
for example: https://keycloak.example.com/realms/myrealm .
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.external.provider.redirect_uri
- **Title**: auth.external.<provider>.redirect_uri
- **Tags**: auth
- **Required**: False
- **Description**:
  The URI a OAuth2 provider will redirect to with the code and state values.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.external.provider.skip_nonce_check
- **Title**: auth.external.<provider>.skip_nonce_check
- **Tags**: auth
- **Required**: False
- **Description**:
  Disables nonce validation during OIDC authentication flow for the specified provider. Enable only when client libraries cannot properly handle nonce verification. Be aware that this reduces security by allowing potential replay attacks with stolen ID tokens.
- **Links**:
  - [Auth Server configuration](https://supabase.com/docs/reference/auth)

### auth.hook.<hook_name>.enabled
- **Title**: auth.hook.<hook_name>.enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Enable Auth Hook. Possible values for `hook_name` are: `custom_access_token`, `send_sms`, `send_email`, `mfa_verification_attempt`, and `password_verification_attempt`.
- **Links**:
  - [Auth Hooks](https://supabase.com/docs/guides/auth/auth-hooks)

### auth.hook.<hook_name>.uri
- **Title**: auth.hook.<hook_name>.uri
- **Tags**: auth
- **Required**: False
- **Default**: 
- **Description**:
  URI of hook to invoke. Should be a http or https function or Postgres function taking the form: `pg-functions://<database>/<schema>/<function-name>`. For example, `pg-functions://postgres/auth/custom-access-token-hook`.
- **Links**:
  - [Auth Hooks](https://supabase.com/docs/guides/auth/auth-hooks)

### auth.hook.<hook_name>.secrets
- **Title**: auth.hook.<hook_name>.secrets
- **Tags**: auth
- **Required**: False
- **Default**: 
- **Description**:
  Configure when using a HTTP Hooks. Takes a list of base64 comma separated values to allow for secret rotation. Currently, Supabase Auth uses only the first value in the list.
- **Links**:
  - [Auth Hooks](https://supabase.com/docs/guides/auth/auth-hooks?queryGroups=language&language=http)

### auth.mfa.totp.enroll_enabled
- **Title**: auth.mfa.totp.enroll_enabled
- **Tags**: auth
- **Required**: False
- **Default**: true
- **Description**:
  Enable TOTP enrollment for multi-factor authentication.
- **Links**:
  - [Auth Multi-Factor Authentication (TOTP)](https://supabase.com/docs/guides/auth/auth-mfa/totp)

### auth.mfa.totp.verify_enabled
- **Title**: auth.mfa.totp.verify_enabled
- **Tags**: auth
- **Required**: False
- **Default**: true
- **Description**:
  Enable TOTP verification for multi-factor authentication.
- **Links**:
  - [Auth Multi-Factor Authentication (TOTP)](https://supabase.com/docs/guides/auth/auth-mfa/totp)

### auth.mfa.max_enrolled_factors
- **Title**: auth.mfa.max_enrolled_factors
- **Tags**: auth
- **Required**: False
- **Default**: 10
- **Description**:
  Control how many MFA factors can be enrolled at once per user.
- **Links**:
  - [Auth Multi-Factor Authentication (TOTP)](https://supabase.com/docs/guides/auth/auth-mfa/totp)

### auth.mfa.phone.enroll_enabled
- **Title**: auth.mfa.phone.enroll_enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Enable Phone enrollment for multi-factor authentication.
- **Links**:
  - [Auth Multi-Factor Authentication (Phone)](https://supabase.com/docs/guides/auth/auth-mfa/phone)

### auth.mfa.phone.otp_length
- **Title**: auth.mfa.phone.otp_length
- **Tags**: auth
- **Required**: False
- **Default**: 6
- **Description**:
  Length of OTP code sent when using phone multi-factor authentication
- **Links**:
  - [Auth Multi-Factor Authentication (Phone)](https://supabase.com/docs/guides/auth/auth-mfa/phone)

### auth.mfa.phone.max_frequency
- **Title**: auth.mfa.phone.max_frequency
- **Tags**: auth
- **Required**: False
- **Default**: 10s
- **Description**:
  The minimum amount of time that must pass between phone requests.
Helps prevent spam by limiting how frequently messages can be sent.
Example values: "10s", "20s", "1m"
- **Links**:
  - [Auth Multi-Factor Authentication (Phone)](https://supabase.com/docs/guides/auth/auth-mfa/phone)

### auth.mfa.phone.otp_length
- **Title**: auth.mfa.phone.otp_length
- **Tags**: auth
- **Required**: False
- **Default**: 6
- **Description**:
  Length of OTP sent when using phone multi-factor authentication
- **Links**:
  - [Auth Multi-Factor Authentication (Phone)](https://supabase.com/docs/guides/auth/auth-mfa/phone)

### auth.mfa.phone.verify_enabled
- **Title**: auth.mfa.phone.verify_enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Enable Phone verification for multi-factor authentication.
- **Links**:
  - [Auth Multi-Factor Authentication (Phone)](https://supabase.com/docs/guides/auth/auth-mfa/phone)

### auth.mfa.web_authn.enroll_enabled
- **Title**: auth.mfa.web_authn.enroll_enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Enable WebAuthn enrollment for multi-factor authentication.
- **Links**:
  - [Auth Multi-Factor Authentication](https://supabase.com/docs/guides/auth/auth-mfa)

### auth.mfa.web_authn.verify_enabled
- **Title**: auth.mfa.web_authn.verify_enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Enable WebAuthn verification for multi-factor authentication.
- **Links**:
  - [Auth Multi-Factor Authentication](https://supabase.com/docs/guides/auth/auth-mfa)

### auth.sessions.timebox
- **Title**: auth.sessions.timebox
- **Tags**: auth
- **Required**: False
- **Default**: 
- **Description**:
  Force log out after the specified duration. Sample values include: '50m', '20h'.
- **Links**:
  - [Auth Sessions](https://supabase.com/docs/guides/auth/sessions)

### auth.sessions.inactivity_timeout
- **Title**: auth.sessions.inactivity_timeout
- **Tags**: auth
- **Required**: False
- **Default**: 
- **Description**:
  Force log out if the user has been inactive longer than the specified duration. Sample values include: '50m', '20h'.
- **Links**:
  - [Auth Sessions](https://supabase.com/docs/guides/auth/sessions)

### auth.third_party.aws_cognito.enabled
- **Title**: auth.third_party.aws_cognito.enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Enable third party auth with AWS Cognito (Amplify)
- **Links**:
  - [Third Party Auth (Cognito)](https://supabase.com/docs/guides/auth/third-party/aws-cognito)

### auth.third_party.aws_cognito.user_pool_id
- **Title**: auth.third_party.aws_cognito.user_pool_id
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  User Pool ID for AWS Cognito (Amplify) that you are integrating with
- **Links**:
  - [Third Party Auth (Cognito)](https://supabase.com/docs/guides/auth/third-party/aws-cognito)

### auth.third_party.aws_cognito.user_pool_region
- **Title**: auth.third_party.aws_cognito.user_pool_region
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  User Pool region for AWS Cognito (Amplify) that you are integrating with. Example values: 'ap-southeast-1', 'us-east-1'
- **Links**:
  - [Third Party Auth (Cognito)](https://supabase.com/docs/guides/auth/third-party/aws-cognito)

### auth.third_party.auth0.enabled
- **Title**: auth.third_party.auth0.enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Enable third party auth with Auth0
- **Links**:
  - [Third Party Auth (Auth0)](https://supabase.com/docs/guides/auth/third-party/auth0)

### auth.third_party.auth0.tenant
- **Title**: auth.third_party.auth0.tenant
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Tenant Identifier for Auth0 instance that you are integrating with
- **Links**:
  - [Third Party Auth (Auth0)](https://supabase.com/docs/guides/auth/third-party/auth0)

### auth.third_party.auth0.tenant_region
- **Title**: auth.third_party.tenant_region
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Tenant region for Auth0 instance that you are integrating with
- **Links**:
  - [Third Party Auth (Auth0)](https://supabase.com/docs/guides/auth/third-party/auth0)

### auth.third_party.firebase.enabled
- **Title**: auth.third_party.firebase.enabled
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Enable third party auth with Firebase
- **Links**:
  - [Third Party Auth (Firebase)](https://supabase.com/docs/guides/auth/third-party/firebase-auth)

### auth.third_party.firebase.project_id
- **Title**: auth.third_party.firebase.project_id
- **Tags**: auth
- **Required**: False
- **Default**: false
- **Description**:
  Project ID for Firebase instance that you are integrating with
- **Links**:
  - [Third Party Auth (Firebase)](https://supabase.com/docs/guides/auth/third-party/firebase-auth)

### edge_runtime.enabled
- **Title**: edge_runtime.enabled
- **Tags**: edge-functions
- **Required**: False
- **Default**: true
- **Description**:
  Enable the local Edge Runtime service for Edge Functions.
- **Links**:

### edge_runtime.policy
- **Title**: edge_runtime.policy
- **Tags**: edge-functions
- **Required**: False
- **Default**: "oneshot"
- **Description**:
  Configure the request handling policy for Edge Functions. Available options:
- `oneshot`: Recommended for development with hot reload support
- `per_worker`: Recommended for load testing scenarios
- **Links**:

### edge_runtime.inspector_port
- **Title**: edge_runtime.inspector_port
- **Tags**: edge-functions
- **Required**: False
- **Default**: 8083
- **Description**:
  Port to attach the Chrome inspector for debugging Edge Functions.
- **Links**:

### functions.function_name.enabled
- **Title**: functions.<function_name>.enabled
- **Tags**: edge-functions
- **Required**: False
- **Default**: true
- **Description**:
  Controls whether a function is deployed or served. When set to false,
the function will be skipped during deployment and won't be served locally.
This is useful for disabling demo functions or temporarily disabling a function
without removing its code.
- **Links**:
  - [`supabase functions` CLI subcommands](https://supabase.com/docs/reference/cli/supabase-functions)

### functions.function_name.verify_jwt
- **Title**: functions.<function_name>.verify_jwt
- **Tags**: edge-functions
- **Required**: False
- **Default**: true
- **Description**:
  By default, when you deploy your Edge Functions or serve them locally, it
will reject requests without a valid JWT in the Authorization header.
Setting this configuration changes the default behavior.

Note that the `--no-verify-jwt` flag overrides this configuration.
- **Links**:
  - [`supabase functions` CLI subcommands](https://supabase.com/docs/reference/cli/supabase-functions)

### functions.function_name.import_map
- **Title**: functions.<function_name>.import_map
- **Tags**: edge-functions
- **Required**: False
- **Description**:
  Specify the Deno import map file to use for the Function.
When not specified, defaults to `supabase/functions/<function_name>/deno.json`.

Note that the `--import-map` flag overrides this configuration.
- **Links**:
  - [`supabase functions` CLI subcommands](https://supabase.com/docs/reference/cli/supabase-functions)

### functions.function_name.entrypoint
- **Title**: functions.<function_name>.entrypoint
- **Tags**: edge-functions
- **Required**: False
- **Description**:
  Specify a custom entrypoint path for the function relative to the project root.
When not specified, defaults to `supabase/functions/<function_name>/index.ts`.
- **Links**:
  - [`supabase functions` CLI subcommands](https://supabase.com/docs/reference/cli/supabase-functions)
- **Usage**:
```
[functions.my_function]
entrypoint = "path/to/custom/function.ts"
```

### analytics.enabled
- **Title**: analytics.enabled
- **Tags**: analytics
- **Required**: False
- **Default**: false
- **Description**:
  Enable the local Logflare service.
- **Links**:
  - [Self-hosted Logflare Configuration](https://supabase.com/docs/reference/self-hosting-analytics/list-endpoints#getting-started)

### analytics.port
- **Title**: analytics.port
- **Tags**: analytics
- **Required**: False
- **Default**: 54327
- **Description**:
  Port to the local Logflare service.
- **Links**:

### analytics.vector_port
- **Title**: analytics.vector_port
- **Tags**: analytics
- **Required**: False
- **Default**: 54328
- **Description**:
  Port to the local syslog ingest service.
- **Links**:

### analytics.backend
- **Title**: analytics.backend
- **Tags**: analytics
- **Required**: False
- **Default**: "postgres"
- **Description**:
  Configure one of the supported backends:

- `postgres`
- `bigquery`
- **Links**:
  - [Self-hosted Logflare Configuration](https://supabase.com/docs/reference/self-hosting-analytics/list-endpoints#getting-started)

### experimental.webhooks.enabled
- **Title**: experimental.webhooks.enabled
- **Tags**: experimental
- **Required**: False
- **Default**: false
- **Description**:
  Automatically enable webhook features on each new created branch
Note: This is an experimental feature and may change in future releases.
- **Links**:

### experimental.orioledb_version
- **Title**: experimental.orioledb_version
- **Tags**: experimental
- **Required**: False
- **Description**:
  Configures Postgres storage engine to use OrioleDB with S3 support.
Note: This is an experimental feature and may change in future releases.
- **Links**:

### experimental.s3_host
- **Title**: experimental.s3_host
- **Tags**: experimental
- **Required**: False
- **Default**: env(S3_HOST)
- **Description**:
  Configures S3 bucket URL for OrioleDB storage.
Format example: <bucket_name>.s3-<region>.amazonaws.com
Note: This is an experimental feature and may change in future releases.
- **Links**:

### experimental.s3_region
- **Title**: experimental.s3_region
- **Tags**: experimental
- **Required**: False
- **Default**: env(S3_REGION)
- **Description**:
  Configures S3 bucket region for OrioleDB storage.
Example: us-east-1
Note: This is an experimental feature and may change in future releases.
- **Links**:

### experimental.s3_access_key
- **Title**: experimental.s3_access_key
- **Tags**: experimental
- **Required**: False
- **Default**: env(S3_ACCESS_KEY)
- **Description**:
  Configures AWS_ACCESS_KEY_ID for S3 bucket access.
DO NOT commit your AWS access key to git. Use environment variable substitution instead.
Note: This is an experimental feature and may change in future releases.
- **Links**:

### experimental.s3_secret_key
- **Title**: experimental.s3_secret_key
- **Tags**: experimental
- **Required**: False
- **Default**: env(S3_SECRET_KEY)
- **Description**:
  Configures AWS_SECRET_ACCESS_KEY for S3 bucket access.
DO NOT commit your AWS secret key to git. Use environment variable substitution instead.
Note: This is an experimental feature and may change in future releases.
- **Links**:

