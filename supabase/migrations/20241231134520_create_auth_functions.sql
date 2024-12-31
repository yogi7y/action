
-- Create user management function
CREATE OR REPLACE FUNCTION public.create_user(
    email text,
    password text
) RETURNS uuid AS $$
DECLARE
    user_id uuid;
    encrypted_pw text;
BEGIN
    user_id := gen_random_uuid();
    encrypted_pw := crypt(password, gen_salt('bf'));

    INSERT INTO auth.users (
        instance_id, id, aud, role, email, encrypted_password, 
        email_confirmed_at, recovery_sent_at, last_sign_in_at,
        raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
        confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
        '00000000-0000-0000-0000-000000000000',
        user_id,
        'authenticated',
        'authenticated',
        email,
        encrypted_pw,
        now(),
        now(),
        now(),
        '{"provider":"email","providers":["email"]}',
        '{}',
        now(),
        now(),
        '',
        '',
        '',
        ''
    );

    INSERT INTO auth.identities (
        id, user_id, identity_data, provider, provider_id,
        last_sign_in_at, created_at, updated_at
    ) VALUES (
        gen_random_uuid(),
        user_id,
        format('{"sub":"%s","email":"%s"}', user_id::text, email)::jsonb,
        'email',
        email,
        now(),
        now(),
        now()
    );

    RETURN user_id;
END;
$$ LANGUAGE plpgsql;

-- Create function to set authentication context
CREATE OR REPLACE FUNCTION set_authenticated_context() RETURNS void AS $$
DECLARE
    created_user_id uuid;
BEGIN
    created_user_id := (SELECT id FROM auth.users WHERE email = 'yogeshparwani99.yp@gmail.com' LIMIT 1);
    
    IF created_user_id IS NULL THEN
        created_user_id := public.create_user('yogeshparwani99.yp@gmail.com', 'localtest');
    END IF;

    PERFORM set_config('request.jwt.claim.sub', created_user_id::text, true);
    PERFORM set_config('request.jwt.claims', 
        format('{"sub": "%s", "role": "authenticated"}', created_user_id)::jsonb::text,
        true);
END;
$$ LANGUAGE plpgsql;