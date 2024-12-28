SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") VALUES
	('00000000-0000-0000-0000-000000000000', '80513220-47a3-427e-81d9-1725c64067bd', '{"action":"user_signedup","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"google"}}', '2024-12-21 21:05:45.5375+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b1fbac6b-17fe-4644-9a62-07ad26f12133', '{"action":"login","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}', '2024-12-21 21:06:57.377957+00', ''),
	('00000000-0000-0000-0000-000000000000', '26a23bc6-589f-43dd-8884-d9da0cf575a9', '{"action":"login","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}', '2024-12-21 21:11:27.511112+00', ''),
	('00000000-0000-0000-0000-000000000000', '9d9d94d1-20e2-4d76-965a-401edab8b03c', '{"action":"logout","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"account"}', '2024-12-21 21:40:26.571447+00', ''),
	('00000000-0000-0000-0000-000000000000', '967b1624-b36f-4d88-8bee-94c34f9c3964', '{"action":"login","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}', '2024-12-21 21:58:14.605087+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c5e33a2d-b481-4b2e-8782-af0278475fa5', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-21 23:04:32.341556+00', ''),
	('00000000-0000-0000-0000-000000000000', '1dad4e64-eac3-4643-9a8e-7fbb7720a5a2', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-21 23:04:32.342506+00', ''),
	('00000000-0000-0000-0000-000000000000', '91ce2295-79a5-4bbd-a71d-3e17aa5d4f9a', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 07:34:24.854591+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b84a16bf-b7ad-474f-9a9e-4fb3ea118843', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 07:34:24.860964+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd891f4e4-1040-447d-a373-098f80e911fc', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 08:33:52.70967+00', ''),
	('00000000-0000-0000-0000-000000000000', '4acbac9b-67ee-4e96-82d4-63abbd09a32c', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 08:33:52.710635+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e5838550-5652-4e9a-acd1-f9c7050b7099', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 10:50:13.438839+00', ''),
	('00000000-0000-0000-0000-000000000000', '9aeb73de-62a2-466f-bd3a-e328e0336296', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 10:50:13.439692+00', ''),
	('00000000-0000-0000-0000-000000000000', '28709626-5947-48b9-8941-d1080d59ed80', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 11:49:34.440606+00', ''),
	('00000000-0000-0000-0000-000000000000', '4cb40c90-ea63-49ef-a9ba-9f22eccfd179', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 11:49:34.441569+00', ''),
	('00000000-0000-0000-0000-000000000000', '915572a8-158f-4f04-b28d-46abf6ed4f7f', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 14:19:06.280084+00', ''),
	('00000000-0000-0000-0000-000000000000', '76b3d7d9-0ac7-40dd-af12-bb4f17e2dfdc', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 14:19:06.281222+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f82442b7-ab9e-4aab-8fc6-309cf606570b', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 15:37:08.679027+00', ''),
	('00000000-0000-0000-0000-000000000000', '41f049d4-5359-4e6d-a5d5-937fd3ef6ace', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 15:37:08.680006+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f7b0850a-430d-4c2d-b63f-93f0aacd97c4', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 16:53:05.563051+00', ''),
	('00000000-0000-0000-0000-000000000000', '34ddeafa-e216-42d2-a656-db19d2896895', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 16:53:05.567305+00', ''),
	('00000000-0000-0000-0000-000000000000', '6f9373c3-892a-43c8-975c-7a97dc6f5b64', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 17:52:29.227924+00', ''),
	('00000000-0000-0000-0000-000000000000', '44aadfa5-e681-470f-ba4f-c3b68a15647c', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-22 17:52:29.228786+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a866677e-53f1-4fa2-ae20-e6a2b8ea3765', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 06:10:40.241148+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c401fc00-c03e-4dd5-8383-72161923addc', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 06:10:40.253525+00', ''),
	('00000000-0000-0000-0000-000000000000', '73ab6eab-e501-4715-989c-33b68fc0be9e', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 07:42:43.372945+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bbdf05df-a640-40f9-adfc-3e86a7416500', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 07:42:43.374902+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a03a787a-3f12-409c-a54c-b6240865888c', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 08:43:31.841856+00', ''),
	('00000000-0000-0000-0000-000000000000', '22673ab6-60f6-427b-916e-5f03121edc96', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 08:43:31.844745+00', ''),
	('00000000-0000-0000-0000-000000000000', '792a7d50-a3db-46e6-afb0-2276f6392961', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 10:09:18.42078+00', ''),
	('00000000-0000-0000-0000-000000000000', '87c082ac-f99d-4c07-9bb5-91b5784f05ef', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 10:09:18.425277+00', ''),
	('00000000-0000-0000-0000-000000000000', '2171abaf-995a-40e8-acee-3c05d78e764c', '{"action":"user_signedup","actor_id":"bce297a4-5818-4cfb-8954-96beb43e5f1c","actor_name":"Yogesh Parwani","actor_username":"yogeshparwani99.yp@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"google"}}', '2024-12-23 10:27:14.485164+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f3b606d3-4f10-4db3-ac3a-92abed1b4099', '{"action":"token_refreshed","actor_id":"bce297a4-5818-4cfb-8954-96beb43e5f1c","actor_name":"Yogesh Parwani","actor_username":"yogeshparwani99.yp@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 11:26:40.230946+00', ''),
	('00000000-0000-0000-0000-000000000000', '61cd638c-89e7-4273-ba84-926eebe2a641', '{"action":"token_revoked","actor_id":"bce297a4-5818-4cfb-8954-96beb43e5f1c","actor_name":"Yogesh Parwani","actor_username":"yogeshparwani99.yp@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 11:26:40.232465+00', ''),
	('00000000-0000-0000-0000-000000000000', '129d29b9-182f-4dbc-a7e4-a999fd51bd33', '{"action":"login","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}', '2024-12-23 12:26:29.568987+00', ''),
	('00000000-0000-0000-0000-000000000000', '311667ae-54a8-4dba-bd43-bf4d29d8621e', '{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"yogeshparwani99.yp@gmail.com","user_id":"bce297a4-5818-4cfb-8954-96beb43e5f1c","user_phone":""}}', '2024-12-23 12:44:10.920324+00', ''),
	('00000000-0000-0000-0000-000000000000', '72d1a657-3e1b-4578-a9d1-5583f793db84', '{"action":"login","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}', '2024-12-23 12:46:56.850139+00', ''),
	('00000000-0000-0000-0000-000000000000', '23f5c7b8-bbeb-4b39-854b-a786d08edbba', '{"action":"login","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}', '2024-12-23 12:56:48.716013+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c3e48af4-339c-47ee-bfd3-819e7ab5fda1', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 14:02:38.879499+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ec303580-839f-4c5e-9fea-d8162dd0a780', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 14:02:38.881067+00', ''),
	('00000000-0000-0000-0000-000000000000', '297499c0-35bd-4827-bf44-313c11604b9d', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 15:02:09.415949+00', ''),
	('00000000-0000-0000-0000-000000000000', '8e23da18-736c-4d41-b591-ca4a41231f29', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 15:02:09.418324+00', ''),
	('00000000-0000-0000-0000-000000000000', '9b20c1d8-7c37-4a02-95d5-0186e135adcf', '{"action":"user_signedup","actor_id":"6f3f7521-04f9-4fea-8cf0-ea056162dc72","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani@coindcx.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"google"}}', '2024-12-23 16:18:47.501075+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ddb15cee-aca2-4dd2-8efd-5bc16474f90b', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 18:29:05.269168+00', ''),
	('00000000-0000-0000-0000-000000000000', '59cf86b3-f3dc-4e93-881c-8e5fc4d679c8', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-23 18:29:05.271359+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e866ef23-f4f2-4dfc-a613-33600514b582', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 02:19:46.508093+00', ''),
	('00000000-0000-0000-0000-000000000000', 'da926ad4-6688-4f5f-89b1-7a96a9f87daa', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 02:19:46.50982+00', ''),
	('00000000-0000-0000-0000-000000000000', '559c1605-e7a8-4576-a40b-7d524057a02f', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 03:19:07.945656+00', ''),
	('00000000-0000-0000-0000-000000000000', '9c0ebfa1-b79f-4c1a-b1cd-bb9703787d53', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 03:19:07.959849+00', ''),
	('00000000-0000-0000-0000-000000000000', '2ed5613a-24d0-49e8-a059-df1f914d1c0a', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 10:55:41.02024+00', ''),
	('00000000-0000-0000-0000-000000000000', '56eae2aa-fb45-4563-b9e6-853dc6c36326', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 10:55:41.027986+00', ''),
	('00000000-0000-0000-0000-000000000000', '9f99ffb6-3894-46bc-a643-51a619abd606', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 12:30:47.164994+00', ''),
	('00000000-0000-0000-0000-000000000000', '9603fe33-46a8-41e4-8d53-65cb64205d00', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 12:30:47.165919+00', ''),
	('00000000-0000-0000-0000-000000000000', '6a5a8ebe-73be-42fc-9d21-5873761a1a98', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 15:41:36.972993+00', ''),
	('00000000-0000-0000-0000-000000000000', '2c92452a-3e9d-4edd-bf0a-7b68055b8762', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 15:41:36.974021+00', ''),
	('00000000-0000-0000-0000-000000000000', '69da0b5b-5960-4aab-b31b-394e4042c3f4', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 16:41:02.194652+00', ''),
	('00000000-0000-0000-0000-000000000000', '443039fb-c013-493b-acf5-245cecda9ba4', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 16:41:02.200608+00', ''),
	('00000000-0000-0000-0000-000000000000', '5c960f01-f707-4fef-99be-55974c91e7eb', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 17:40:23.66863+00', ''),
	('00000000-0000-0000-0000-000000000000', '898ced5a-a88a-485f-8e85-54c9e52d4baf', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 17:40:23.672224+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bd283f61-b0be-411d-b684-f01c0fbea7d7', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 18:39:54.017668+00', ''),
	('00000000-0000-0000-0000-000000000000', '58d3aa55-900c-4127-8971-9a3c1ebeb302', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-24 18:39:54.019384+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fc4c0888-1f24-42a7-a539-2191a03633af', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 06:50:31.789873+00', ''),
	('00000000-0000-0000-0000-000000000000', '4c8b80e5-6741-49e2-a0d4-393aac474fc5', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 06:50:31.804081+00', ''),
	('00000000-0000-0000-0000-000000000000', '4d3b689e-f6ab-4dcb-8bd8-69eb3341e158', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 07:49:56.550516+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c2087ab2-b7f6-4b8e-b03b-a8b3b86c70a9', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 07:49:56.555741+00', ''),
	('00000000-0000-0000-0000-000000000000', '08e799fd-dfd0-4fa4-8ccc-04fcdf491480', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 08:49:30.629571+00', ''),
	('00000000-0000-0000-0000-000000000000', '01a6a11e-8748-426c-9280-2dd10bbeb861', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 08:49:30.630484+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dce9a6d6-da09-483d-94d6-114bd3d8ac34', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 09:58:17.357611+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e37f6f8d-3433-4c13-9d3e-a72b9c9355e9', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 09:58:17.358788+00', ''),
	('00000000-0000-0000-0000-000000000000', '79fb74f8-35c9-4f0f-b326-f5dc3637392d', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 10:57:45.687775+00', ''),
	('00000000-0000-0000-0000-000000000000', '3b27b167-7f96-4214-8044-b0b6eb723c9b', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 10:57:45.68948+00', ''),
	('00000000-0000-0000-0000-000000000000', 'eeb636db-ef62-461b-a023-d9186258fe9f', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 14:21:44.564605+00', ''),
	('00000000-0000-0000-0000-000000000000', '36a1e844-6b95-4eb8-af16-7c92a68004a7', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 14:21:44.572531+00', ''),
	('00000000-0000-0000-0000-000000000000', 'db0a3068-945b-4b4c-ab82-6a2201bebe91', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 15:21:05.792523+00', ''),
	('00000000-0000-0000-0000-000000000000', '8918cb4a-1fef-46d2-b5f4-b578c6d411d0', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-25 15:21:05.794612+00', ''),
	('00000000-0000-0000-0000-000000000000', '78b608fb-1512-44bc-b157-ec17d7db025c', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-26 06:08:09.726001+00', ''),
	('00000000-0000-0000-0000-000000000000', '1124a885-5aca-492b-8ce2-5c177290c222', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-26 06:08:09.743679+00', ''),
	('00000000-0000-0000-0000-000000000000', '6ca16ee2-5ff2-460a-a5d9-c29d04082f97', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-26 14:08:58.5627+00', ''),
	('00000000-0000-0000-0000-000000000000', '983747b2-01d0-4ff5-9e9f-5e8d4dfb3d72', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-26 14:08:58.584222+00', ''),
	('00000000-0000-0000-0000-000000000000', '59e1dd0c-7738-4bc6-9927-c39ebe8e42e1', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-26 15:54:14.378462+00', ''),
	('00000000-0000-0000-0000-000000000000', '73035100-fdc8-46aa-bc18-d57cb6729d21', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-26 15:54:14.3814+00', ''),
	('00000000-0000-0000-0000-000000000000', '346770d8-583b-464b-924c-383ad97452de', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-26 16:58:43.64749+00', ''),
	('00000000-0000-0000-0000-000000000000', '8c876a2a-8cc3-4d32-9c07-0a791c6ccb4f', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-26 16:58:43.648416+00', ''),
	('00000000-0000-0000-0000-000000000000', '1416513d-48b1-4737-aa3a-d5cbb04f34bb', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-27 10:24:11.301099+00', ''),
	('00000000-0000-0000-0000-000000000000', '2000ddc2-4d09-4ab2-b1ea-7c94f8dbebb3', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-27 10:24:11.316886+00', ''),
	('00000000-0000-0000-0000-000000000000', 'caaabd13-033d-42c9-a673-c1e14d6dd1bc', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-27 11:23:33.164082+00', ''),
	('00000000-0000-0000-0000-000000000000', '44d17a99-0471-4687-b304-522ab33089d8', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-27 11:23:33.166431+00', ''),
	('00000000-0000-0000-0000-000000000000', '7259f7f2-64b6-4ccb-ba1e-6d96523f217b', '{"action":"token_refreshed","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-27 16:04:49.983467+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c6fa9394-8691-4bec-b6ab-b8dcc04b7718', '{"action":"token_revoked","actor_id":"b1cbd649-91fc-43f4-8c2e-d8419f5a6e08","actor_name":"Yogesh Parwani","actor_username":"yogesh.parwani.7y@gmail.com","actor_via_sso":false,"log_type":"token"}', '2024-12-27 16:04:49.994174+00', '');


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', 'authenticated', 'authenticated', 'yogesh.parwani.7y@gmail.com', NULL, '2024-12-21 21:05:45.540729+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-12-23 12:56:48.718375+00', '{"provider": "google", "providers": ["google"]}', '{"iss": "https://accounts.google.com", "sub": "115388833037703854835", "name": "Yogesh Parwani", "email": "yogesh.parwani.7y@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocIQQLAOkiAywUHyKYKToko2Y2rmk0pWk2AVoACe6M0Pxo-zuQ=s96-c", "full_name": "Yogesh Parwani", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocIQQLAOkiAywUHyKYKToko2Y2rmk0pWk2AVoACe6M0Pxo-zuQ=s96-c", "provider_id": "115388833037703854835", "email_verified": true, "phone_verified": false}', NULL, '2024-12-21 21:05:45.507515+00', '2024-12-27 16:04:50.012614+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '6f3f7521-04f9-4fea-8cf0-ea056162dc72', 'authenticated', 'authenticated', 'yogesh.parwani@coindcx.com', NULL, '2024-12-23 16:18:47.502422+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-12-23 16:18:47.505137+00', '{"provider": "google", "providers": ["google"]}', '{"iss": "https://accounts.google.com", "sub": "115938633686768146270", "name": "Yogesh Parwani", "email": "yogesh.parwani@coindcx.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocKquVg-mf-DWTaG8ysDXeWzipJj0WgLCMTJ5GcFe1nS7xXbDg=s96-c", "full_name": "Yogesh Parwani", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocKquVg-mf-DWTaG8ysDXeWzipJj0WgLCMTJ5GcFe1nS7xXbDg=s96-c", "provider_id": "115938633686768146270", "custom_claims": {"hd": "coindcx.com"}, "email_verified": true, "phone_verified": false}', NULL, '2024-12-23 16:18:47.488134+00', '2024-12-23 16:18:47.510811+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('115388833037703854835', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', '{"iss": "https://accounts.google.com", "sub": "115388833037703854835", "name": "Yogesh Parwani", "email": "yogesh.parwani.7y@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocIQQLAOkiAywUHyKYKToko2Y2rmk0pWk2AVoACe6M0Pxo-zuQ=s96-c", "full_name": "Yogesh Parwani", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocIQQLAOkiAywUHyKYKToko2Y2rmk0pWk2AVoACe6M0Pxo-zuQ=s96-c", "provider_id": "115388833037703854835", "email_verified": true, "phone_verified": false}', 'google', '2024-12-21 21:05:45.533016+00', '2024-12-21 21:05:45.533075+00', '2024-12-23 12:56:48.711112+00', 'e3efed25-dc76-4949-9092-76c2d85b600f'),
	('115938633686768146270', '6f3f7521-04f9-4fea-8cf0-ea056162dc72', '{"iss": "https://accounts.google.com", "sub": "115938633686768146270", "name": "Yogesh Parwani", "email": "yogesh.parwani@coindcx.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocKquVg-mf-DWTaG8ysDXeWzipJj0WgLCMTJ5GcFe1nS7xXbDg=s96-c", "full_name": "Yogesh Parwani", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocKquVg-mf-DWTaG8ysDXeWzipJj0WgLCMTJ5GcFe1nS7xXbDg=s96-c", "provider_id": "115938633686768146270", "custom_claims": {"hd": "coindcx.com"}, "email_verified": true, "phone_verified": false}', 'google', '2024-12-23 16:18:47.495684+00', '2024-12-23 16:18:47.495744+00', '2024-12-23 16:18:47.495744+00', '85aa6cec-6bbb-477d-b278-5a0c195339a8');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag") VALUES
	('e0a88473-a229-4344-a7d2-310d6b77321b', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', '2024-12-21 21:05:45.543807+00', '2024-12-21 21:05:45.543807+00', NULL, 'aal1', NULL, NULL, 'Dart/3.6 (dart:io)', '45.127.44.126', NULL),
	('5aa96e65-9756-424a-9010-217096f8ef8e', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', '2024-12-21 21:06:57.378866+00', '2024-12-21 21:06:57.378866+00', NULL, 'aal1', NULL, NULL, 'Dart/3.6 (dart:io)', '45.127.44.126', NULL),
	('4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', '2024-12-21 21:58:14.606103+00', '2024-12-23 10:09:18.432987+00', NULL, 'aal1', NULL, '2024-12-23 10:09:18.432918', 'Dart/3.6 (dart:io)', '45.127.44.32', NULL),
	('338db650-eaf5-4bfa-8199-51208e113f69', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', '2024-12-23 12:26:29.569963+00', '2024-12-23 12:26:29.569963+00', NULL, 'aal1', NULL, NULL, 'Dart/3.6 (dart:io)', '45.127.44.32', NULL),
	('ba8ebf1f-deba-4065-bdd2-bb5649e45cad', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', '2024-12-23 12:46:56.851141+00', '2024-12-23 12:46:56.851141+00', NULL, 'aal1', NULL, NULL, 'Dart/3.6 (dart:io)', '45.127.44.32', NULL),
	('04f694bc-b721-466c-a2ef-b323dfad2d3e', '6f3f7521-04f9-4fea-8cf0-ea056162dc72', '2024-12-23 16:18:47.505207+00', '2024-12-23 16:18:47.505207+00', NULL, 'aal1', NULL, NULL, 'Dart/3.6 (dart:io)', '45.127.44.32', NULL),
	('efe2fb92-e613-43f3-8eac-1e4a0da79f2b', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', '2024-12-23 12:56:48.718458+00', '2024-12-27 16:04:50.020219+00', NULL, 'aal1', NULL, '2024-12-27 16:04:50.02013', 'Dart/3.6 (dart:io)', '45.127.45.238', NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('e0a88473-a229-4344-a7d2-310d6b77321b', '2024-12-21 21:05:45.556806+00', '2024-12-21 21:05:45.556806+00', 'oauth', '09796b83-1982-4904-9c98-c797f9e2dead'),
	('5aa96e65-9756-424a-9010-217096f8ef8e', '2024-12-21 21:06:57.381591+00', '2024-12-21 21:06:57.381591+00', 'oauth', 'bc7c1a96-ae48-4baa-989e-c75eff80a556'),
	('4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8', '2024-12-21 21:58:14.609714+00', '2024-12-21 21:58:14.609714+00', 'oauth', 'cb4843a3-247e-4a7e-b3a6-4f89649c1f3f'),
	('338db650-eaf5-4bfa-8199-51208e113f69', '2024-12-23 12:26:29.5737+00', '2024-12-23 12:26:29.5737+00', 'oauth', '1ebe7263-643d-4caa-9ed1-05009b941db5'),
	('ba8ebf1f-deba-4065-bdd2-bb5649e45cad', '2024-12-23 12:46:56.856201+00', '2024-12-23 12:46:56.856201+00', 'oauth', '499735e0-1396-49bb-a57f-85f999e9e94c'),
	('efe2fb92-e613-43f3-8eac-1e4a0da79f2b', '2024-12-23 12:56:48.722396+00', '2024-12-23 12:56:48.722396+00', 'oauth', '67718d90-2d16-4099-aeed-4cb2f2a2db58'),
	('04f694bc-b721-466c-a2ef-b323dfad2d3e', '2024-12-23 16:18:47.511284+00', '2024-12-23 16:18:47.511284+00', 'oauth', '3aa20de4-6c2b-439d-82fa-300430bf0a30');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 1, 'dSi858_akzU5LC-vv2GqvQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', false, '2024-12-21 21:05:45.550059+00', '2024-12-21 21:05:45.550059+00', NULL, 'e0a88473-a229-4344-a7d2-310d6b77321b'),
	('00000000-0000-0000-0000-000000000000', 2, 'b6BZ2grUL8pnGsKDH7ORvw', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', false, '2024-12-21 21:06:57.379825+00', '2024-12-21 21:06:57.379825+00', NULL, '5aa96e65-9756-424a-9010-217096f8ef8e'),
	('00000000-0000-0000-0000-000000000000', 4, 'XW9pc556L5cvbzI7eltCkQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-21 21:58:14.607174+00', '2024-12-21 23:04:32.34306+00', NULL, '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 5, 'LCt9SPC5u03go10eJ9vPeQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-21 23:04:32.343818+00', '2024-12-22 07:34:24.861536+00', 'XW9pc556L5cvbzI7eltCkQ', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 6, 'GZ8utVlZGogWLkFSkuouQA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-22 07:34:24.864404+00', '2024-12-22 08:33:52.711131+00', 'LCt9SPC5u03go10eJ9vPeQ', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 7, '0lqVD-vLaIgjM8kOvfbkhQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-22 08:33:52.712535+00', '2024-12-22 10:50:13.440183+00', 'GZ8utVlZGogWLkFSkuouQA', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 8, 'mHo7hKpbZYeHUQ0htUF0Bg', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-22 10:50:13.440776+00', '2024-12-22 11:49:34.442167+00', '0lqVD-vLaIgjM8kOvfbkhQ', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 9, '_KGSsvi2h6p2bflbW6EsSw', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-22 11:49:34.44284+00', '2024-12-22 14:19:06.281788+00', 'mHo7hKpbZYeHUQ0htUF0Bg', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 10, '1svJAWE-DyqORQVluko14Q', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-22 14:19:06.282512+00', '2024-12-22 15:37:08.680567+00', '_KGSsvi2h6p2bflbW6EsSw', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 11, '09MnsGy0uQe3PYqERMr9yA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-22 15:37:08.681292+00', '2024-12-22 16:53:05.567932+00', '1svJAWE-DyqORQVluko14Q', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 12, 'ep4x4y0AxOqBnS9St-K6Gg', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-22 16:53:05.569885+00', '2024-12-22 17:52:29.229263+00', '09MnsGy0uQe3PYqERMr9yA', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 13, 'DC06R9pRTQxiNozxETCm9g', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-22 17:52:29.22985+00', '2024-12-23 06:10:40.254113+00', 'ep4x4y0AxOqBnS9St-K6Gg', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 14, 'XHgbDVqP9_PS2WyW0gaCiQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-23 06:10:40.26116+00', '2024-12-23 07:42:43.375527+00', 'DC06R9pRTQxiNozxETCm9g', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 15, 'VBCM6cOZ4Cktb2wBVahUEA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-23 07:42:43.376218+00', '2024-12-23 08:43:31.845515+00', 'XHgbDVqP9_PS2WyW0gaCiQ', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 16, 'AezMExRFwN4vCGO10g1b3g', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-23 08:43:31.846264+00', '2024-12-23 10:09:18.425932+00', 'VBCM6cOZ4Cktb2wBVahUEA', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 17, '3O62sevA857nd-3dS4BWBg', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', false, '2024-12-23 10:09:18.427345+00', '2024-12-23 10:09:18.427345+00', 'AezMExRFwN4vCGO10g1b3g', '4b4b4b09-ee5f-4a33-967c-fe01ad6db3c8'),
	('00000000-0000-0000-0000-000000000000', 20, 'bEy2Ptgk8uT89Kh-UVtBDA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', false, '2024-12-23 12:26:29.571032+00', '2024-12-23 12:26:29.571032+00', NULL, '338db650-eaf5-4bfa-8199-51208e113f69'),
	('00000000-0000-0000-0000-000000000000', 21, 'TlseWJ3uRmdfODhgKcBCyg', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', false, '2024-12-23 12:46:56.852262+00', '2024-12-23 12:46:56.852262+00', NULL, 'ba8ebf1f-deba-4065-bdd2-bb5649e45cad'),
	('00000000-0000-0000-0000-000000000000', 22, 'VYZAoSfpQV7RjRM9Zz2nUw', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-23 12:56:48.71965+00', '2024-12-23 14:02:38.881605+00', NULL, 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 23, 'O7MPxnnORBrE3ugMMShAMg', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-23 14:02:38.88289+00', '2024-12-23 15:02:09.418868+00', 'VYZAoSfpQV7RjRM9Zz2nUw', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 25, 'zdS-Ny1DhCbEhDVetyfbRg', '6f3f7521-04f9-4fea-8cf0-ea056162dc72', false, '2024-12-23 16:18:47.506863+00', '2024-12-23 16:18:47.506863+00', NULL, '04f694bc-b721-466c-a2ef-b323dfad2d3e'),
	('00000000-0000-0000-0000-000000000000', 24, 'T88EtaVUPTZgvkhNDkJbEA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-23 15:02:09.421407+00', '2024-12-23 18:29:05.271937+00', 'O7MPxnnORBrE3ugMMShAMg', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 26, 'Ev1jSnDY2gpLZMcO5rCvTA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-23 18:29:05.273323+00', '2024-12-24 02:19:46.510387+00', 'T88EtaVUPTZgvkhNDkJbEA', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 27, 'fvEpuD4aIBsYWGs47e37PQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-24 02:19:46.512895+00', '2024-12-24 03:19:07.960648+00', 'Ev1jSnDY2gpLZMcO5rCvTA', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 28, 'rAGhbQ8YFhWxPOCt7DqWOQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-24 03:19:07.96725+00', '2024-12-24 10:55:41.028602+00', 'fvEpuD4aIBsYWGs47e37PQ', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 29, 'GS3KhmVyMEYxhf2RcnC6fg', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-24 10:55:41.030025+00', '2024-12-24 12:30:47.166422+00', 'rAGhbQ8YFhWxPOCt7DqWOQ', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 30, 'i-UVtmmU3Xl2_uOLpRBHIQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-24 12:30:47.167108+00', '2024-12-24 15:41:36.974585+00', 'GS3KhmVyMEYxhf2RcnC6fg', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 31, 'OJt27_JUOrDgoVNRIcX6lQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-24 15:41:36.975937+00', '2024-12-24 16:41:02.201411+00', 'i-UVtmmU3Xl2_uOLpRBHIQ', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 32, '6tCgIJhw8oKBFIkoVQjsSw', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-24 16:41:02.205725+00', '2024-12-24 17:40:23.672859+00', 'OJt27_JUOrDgoVNRIcX6lQ', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 33, 'O4dtIo3xj9COzAOFgWSPMw', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-24 17:40:23.675379+00', '2024-12-24 18:39:54.020099+00', '6tCgIJhw8oKBFIkoVQjsSw', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 34, 'AxDZg3xLel9l5qLOi7-8gg', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-24 18:39:54.023211+00', '2024-12-25 06:50:31.80472+00', 'O4dtIo3xj9COzAOFgWSPMw', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 35, 'A1cOXu9VDTfI5ofwG5re0Q', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-25 06:50:31.814618+00', '2024-12-25 07:49:56.556528+00', 'AxDZg3xLel9l5qLOi7-8gg', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 36, '0fubDpsEzsgEzp5FbsaGZg', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-25 07:49:56.558008+00', '2024-12-25 08:49:30.630967+00', 'A1cOXu9VDTfI5ofwG5re0Q', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 37, 'AHDgqKU7U_8cP_yw6pPULA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-25 08:49:30.633548+00', '2024-12-25 09:58:17.359379+00', '0fubDpsEzsgEzp5FbsaGZg', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 38, '1LxhKoORziSkH12GEDQv-Q', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-25 09:58:17.361716+00', '2024-12-25 10:57:45.690015+00', 'AHDgqKU7U_8cP_yw6pPULA', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 39, 'A6D1lZB6ZScwiOJZEJaxbw', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-25 10:57:45.69197+00', '2024-12-25 14:21:44.573307+00', '1LxhKoORziSkH12GEDQv-Q', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 40, 'WJM0M-7vI52KJ7IY2TrvAA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-25 14:21:44.584672+00', '2024-12-25 15:21:05.795132+00', 'A6D1lZB6ZScwiOJZEJaxbw', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 41, 'BaYLnRLVkGaR63KcfGOWDw', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-25 15:21:05.798864+00', '2024-12-26 06:08:09.744464+00', 'WJM0M-7vI52KJ7IY2TrvAA', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 42, 'Lc0qtDfB_O7BiWwSwX4szQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-26 06:08:09.75071+00', '2024-12-26 14:08:58.58489+00', 'BaYLnRLVkGaR63KcfGOWDw', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 43, 'xlB4IQxLxJ1_f4n2ONrYVA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-26 14:08:58.593264+00', '2024-12-26 15:54:14.381941+00', 'Lc0qtDfB_O7BiWwSwX4szQ', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 44, 'krygacHunI32IjJNl0xt1g', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-26 15:54:14.384687+00', '2024-12-26 16:58:43.6489+00', 'xlB4IQxLxJ1_f4n2ONrYVA', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 45, 'qcduXqRMJKiuPGB9kygwyQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-26 16:58:43.650865+00', '2024-12-27 10:24:11.317513+00', 'krygacHunI32IjJNl0xt1g', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 46, '77iHxKM4oHFyzoFIO-pKdA', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-27 10:24:11.334342+00', '2024-12-27 11:23:33.167747+00', 'qcduXqRMJKiuPGB9kygwyQ', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 47, 'LnePMe8r0jnsPUEUgaSnxQ', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', true, '2024-12-27 11:23:33.17021+00', '2024-12-27 16:04:49.998235+00', '77iHxKM4oHFyzoFIO-pKdA', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b'),
	('00000000-0000-0000-0000-000000000000', 48, '2Y_ePMLGE9CsuFMAH7-f1Q', 'b1cbd649-91fc-43f4-8c2e-d8419f5a6e08', false, '2024-12-27 16:04:50.010194+00', '2024-12-27 16:04:50.010194+00', 'LnePMe8r0jnsPUEUgaSnxQ', 'efe2fb92-e613-43f3-8eac-1e4a0da79f2b');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--



--
-- Data for Name: contexts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."contexts" ("id", "name", "created_at", "updated_at") VALUES
	('a2a4f270-ef32-44ce-8c17-9e5d993b920a', 'Home', '2024-12-22 15:58:54.171348+00', '2024-12-22 15:58:54.171348+00'),
	('ea12c8a5-52eb-42ea-8411-f006cf9ac972', 'Computer', '2024-12-22 15:58:54.171348+00', '2024-12-22 15:58:54.171348+00'),
	('422d8ba7-bbdd-49ee-bdfb-8b5798932ba5', 'Phone', '2024-12-22 15:58:54.171348+00', '2024-12-22 15:58:54.171348+00'),
	('10ac8399-746f-49f4-85ef-f09e17ea074c', 'Errands', '2024-12-22 15:58:54.171348+00', '2024-12-22 15:58:54.171348+00'),
	('78a1a739-d6eb-4aaa-b66d-94562205fdea', 'Office', '2024-12-22 15:58:54.171348+00', '2024-12-22 15:58:54.171348+00');


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."projects" ("id", "name", "created_at", "updated_at") VALUES
	('67bfe90c-5a9e-4b64-8dc5-70e31b47287f', 'Personal Website', '2024-12-22 15:58:28.573223+00', '2024-12-22 15:58:28.573223+00'),
	('09b77c6c-aa25-4486-b563-86307a309126', 'Home Renovation', '2024-12-22 15:58:28.573223+00', '2024-12-22 15:58:28.573223+00'),
	('eadeda8b-8f45-4e50-8dd4-67a49bca5490', 'Learning Flutter', '2024-12-22 15:58:28.573223+00', '2024-12-22 15:58:28.573223+00'),
	('049e9c64-81f0-47cf-afba-68147cd05726', 'Fitness Goals', '2024-12-22 15:58:28.573223+00', '2024-12-22 15:58:28.573223+00');


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."tasks" ("id", "name", "status", "due_date", "project_id", "context_id", "created_at", "updated_at") VALUES
	('9cfb4fd7-6725-42c8-83bc-33e9d336f455', 'Hey today ', 'todo', '2024-12-26', NULL, NULL, '2024-12-26 17:47:02.978353+00', '2024-12-26 17:47:02.978353+00'),
	('ad09b527-0eb4-4c35-a140-29196a1c6c2f', 'Adding take via dark mode scheduled for tomorrow ', 'done', '2024-12-28', 'eadeda8b-8f45-4e50-8dd4-67a49bca5490', 'ea12c8a5-52eb-42ea-8411-f006cf9ac972', '2024-12-27 12:13:06.711528+00', '2024-12-27 12:13:06.711528+00'),
	('48429454-a03b-4a1d-bcd9-3e5fa0e7754e', 'Adding some new task today ', 'done', '2024-12-27', 'eadeda8b-8f45-4e50-8dd4-67a49bca5490', 'a2a4f270-ef32-44ce-8c17-9e5d993b920a', '2024-12-27 12:10:52.523018+00', '2024-12-27 12:10:52.523018+00'),
	('e7ecc051-0bf6-4e64-9099-54f204f03a9d', 'Keep adding', 'done', NULL, NULL, NULL, '2024-12-25 11:17:27.371215+00', '2024-12-25 11:17:27.371215+00'),
	('6cbcf5a2-57ee-4e73-954d-5ddb765dc842', 'Oh couldn''t s the the animation ', 'todo', NULL, NULL, NULL, '2024-12-25 11:38:57.066482+00', '2024-12-25 11:38:57.066482+00'),
	('9c1b60e0-e79a-4a86-aa4b-7c8597158297', 'Nice. It looks good!', 'todo', NULL, NULL, NULL, '2024-12-25 11:39:08.489753+00', '2024-12-25 11:39:08.489753+00'),
	('092408fc-25cb-4ca3-9ab7-2ef37cc71a84', 'Another one', 'done', NULL, NULL, NULL, '2024-12-25 11:17:21.179129+00', '2024-12-25 11:17:21.179129+00'),
	('f31da1db-2c06-46e5-84f3-1e5437a44de9', 'Something else ', 'done', NULL, NULL, NULL, '2024-12-25 11:17:17.732197+00', '2024-12-25 11:17:17.732197+00'),
	('1e0c89c7-c372-414a-b067-02a1b32d3c22', 'Keep going ', 'done', NULL, NULL, NULL, '2024-12-25 11:17:24.166317+00', '2024-12-25 11:17:24.166317+00'),
	('605ef476-49d9-48c7-88af-56d01b541199', 'First task ', 'done', NULL, NULL, NULL, '2024-12-25 11:17:13.827029+00', '2024-12-25 11:17:13.827029+00'),
	('8306e6f0-90f2-434e-a78d-78cfdec0cddf', 'More more more 🥰😗🥰😗😂🤣😀😍😄😘😄😘😍😗😌😗😌😗😌☺️😗☺️😗😊😃😅🥲😭🥲🙏👀', 'todo', NULL, NULL, NULL, '2024-12-25 11:17:50.664059+00', '2024-12-25 11:17:50.664059+00'),
	('c7ff748f-fb8e-4bf3-80d6-99cea3a55a2b', 'Adding a new task via dark mode', 'todo', NULL, NULL, NULL, '2024-12-25 11:38:49.841818+00', '2024-12-25 11:38:49.841818+00'),
	('ecd1d734-c3b1-496a-af94-3ca30e0c6ca5', 'Some emojis 😻🤣', 'done', NULL, NULL, NULL, '2024-12-25 11:17:37.479525+00', '2024-12-25 11:17:37.479525+00'),
	('cee4a156-f3dd-4371-841a-53d5eb7da3cb', 'You''re doing great!', 'done', NULL, NULL, NULL, '2024-12-25 11:17:33.322153+00', '2024-12-25 11:17:33.322153+00'),
	('e649414b-1546-4512-b14f-e8f980741259', 'Task with project.', 'todo', NULL, NULL, NULL, '2024-12-26 16:59:11.360705+00', '2024-12-26 16:59:11.360705+00'),
	('390d0975-fb89-49b7-b687-5df9ad4c7592', 'Work ', 'todo', NULL, '09b77c6c-aa25-4486-b563-86307a309126', NULL, '2024-12-26 17:04:34.126742+00', '2024-12-26 17:04:34.126742+00'),
	('d10382cf-f21f-482e-b389-14f6ac4e68c8', 'Some task ', 'todo', NULL, 'eadeda8b-8f45-4e50-8dd4-67a49bca5490', NULL, '2024-12-26 17:06:34.627077+00', '2024-12-26 17:06:34.627077+00'),
	('8c159aa8-1ab8-4e80-b2c0-8ed06f50a5b9', 'Adding multiple tasks s', 'todo', NULL, '049e9c64-81f0-47cf-afba-68147cd05726', NULL, '2024-12-26 17:17:36.13705+00', '2024-12-26 17:17:36.13705+00'),
	('4d62586d-0d3b-48b9-a241-6c8eeae41bcd', 'Task with project and context. ', 'todo', NULL, 'eadeda8b-8f45-4e50-8dd4-67a49bca5490', 'ea12c8a5-52eb-42ea-8411-f006cf9ac972', '2024-12-26 17:29:53.770078+00', '2024-12-26 17:29:53.770078+00');


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 48, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('"pgsodium"."key_key_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

RESET ALL;
