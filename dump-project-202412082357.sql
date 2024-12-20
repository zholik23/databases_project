PGDMP         9                |            project    15.8    15.8 C    E           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            F           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            G           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            H           1262    17325    project    DATABASE     �   CREATE DATABASE project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251' TABLESPACE = database;
    DROP DATABASE project;
                admin    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                pg_database_owner    false            I           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   pg_database_owner    false    4            �            1259    17439    User    TABLE     �   CREATE TABLE public."User" (
    userid integer NOT NULL,
    username character varying(255) NOT NULL,
    passwordhash character varying(255) NOT NULL,
    role character varying
);
    DROP TABLE public."User";
       public         heap    admin    false    4            �            1259    17438    User_userid_seq    SEQUENCE     �   CREATE SEQUENCE public."User_userid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."User_userid_seq";
       public          admin    false    4    223            J           0    0    User_userid_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."User_userid_seq" OWNED BY public."User".userid;
          public          admin    false    222            �            1259    17467    blogpost    TABLE     �   CREATE TABLE public.blogpost (
    postid integer NOT NULL,
    authorid integer,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.blogpost;
       public         heap    postgres    false    4            K           0    0    TABLE blogpost    ACL     E   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.blogpost TO admin;
          public          postgres    false    225            �            1259    17466    blogpost_postid_seq    SEQUENCE     �   CREATE SEQUENCE public.blogpost_postid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.blogpost_postid_seq;
       public          postgres    false    4    225            L           0    0    blogpost_postid_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.blogpost_postid_seq OWNED BY public.blogpost.postid;
          public          postgres    false    224            M           0    0    SEQUENCE blogpost_postid_seq    ACL     D   GRANT SELECT,USAGE ON SEQUENCE public.blogpost_postid_seq TO admin;
          public          postgres    false    224            �            1259    17371    drink    TABLE     �   CREATE TABLE public.drink (
    drinkid integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    flavorprofile character varying(50) NOT NULL,
    moodid integer,
    photo character varying(255)
);
    DROP TABLE public.drink;
       public         heap    admin    false    4            �            1259    17370    drink_drinkid_seq    SEQUENCE     �   CREATE SEQUENCE public.drink_drinkid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.drink_drinkid_seq;
       public          admin    false    219    4            N           0    0    drink_drinkid_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.drink_drinkid_seq OWNED BY public.drink.drinkid;
          public          admin    false    218            �            1259    17347    mood    TABLE     �   CREATE TABLE public.mood (
    moodid integer NOT NULL,
    moodname character varying(255) NOT NULL,
    description text,
    hybridmood boolean DEFAULT false
);
    DROP TABLE public.mood;
       public         heap    admin    false    4            �            1259    17346    mood_moodid_seq    SEQUENCE     �   CREATE SEQUENCE public.mood_moodid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.mood_moodid_seq;
       public          admin    false    215    4            O           0    0    mood_moodid_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.mood_moodid_seq OWNED BY public.mood.moodid;
          public          admin    false    214            �            1259    17401    popularcombinations    TABLE     �   CREATE TABLE public.popularcombinations (
    combinationid integer NOT NULL,
    snackid integer,
    drinkid integer,
    popularitycount integer DEFAULT 0
);
 '   DROP TABLE public.popularcombinations;
       public         heap    admin    false    4            �            1259    17400 %   popularcombinations_combinationid_seq    SEQUENCE     �   CREATE SEQUENCE public.popularcombinations_combinationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.popularcombinations_combinationid_seq;
       public          admin    false    4    221            P           0    0 %   popularcombinations_combinationid_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.popularcombinations_combinationid_seq OWNED BY public.popularcombinations.combinationid;
          public          admin    false    220            �            1259    17483    recommendationlog    TABLE     �   CREATE TABLE public.recommendationlog (
    logid integer NOT NULL,
    userid integer,
    moodid integer,
    snackid integer,
    drinkid integer,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 %   DROP TABLE public.recommendationlog;
       public         heap    postgres    false    4            �            1259    17482    recommendationlog_logid_seq    SEQUENCE     �   CREATE SEQUENCE public.recommendationlog_logid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.recommendationlog_logid_seq;
       public          postgres    false    4    227            Q           0    0    recommendationlog_logid_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.recommendationlog_logid_seq OWNED BY public.recommendationlog.logid;
          public          postgres    false    226            �            1259    17359    snack    TABLE     �   CREATE TABLE public.snack (
    snackid integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    flavorprofile character varying(50) NOT NULL,
    moodid integer,
    photo character varying(255)
);
    DROP TABLE public.snack;
       public         heap    admin    false    4            �            1259    17358    snack_snackid_seq    SEQUENCE     �   CREATE SEQUENCE public.snack_snackid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.snack_snackid_seq;
       public          admin    false    4    217            R           0    0    snack_snackid_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.snack_snackid_seq OWNED BY public.snack.snackid;
          public          admin    false    216            �           2604    17442    User userid    DEFAULT     n   ALTER TABLE ONLY public."User" ALTER COLUMN userid SET DEFAULT nextval('public."User_userid_seq"'::regclass);
 <   ALTER TABLE public."User" ALTER COLUMN userid DROP DEFAULT;
       public          admin    false    222    223    223            �           2604    17470    blogpost postid    DEFAULT     r   ALTER TABLE ONLY public.blogpost ALTER COLUMN postid SET DEFAULT nextval('public.blogpost_postid_seq'::regclass);
 >   ALTER TABLE public.blogpost ALTER COLUMN postid DROP DEFAULT;
       public          postgres    false    225    224    225            �           2604    17374    drink drinkid    DEFAULT     n   ALTER TABLE ONLY public.drink ALTER COLUMN drinkid SET DEFAULT nextval('public.drink_drinkid_seq'::regclass);
 <   ALTER TABLE public.drink ALTER COLUMN drinkid DROP DEFAULT;
       public          admin    false    219    218    219            �           2604    17350    mood moodid    DEFAULT     j   ALTER TABLE ONLY public.mood ALTER COLUMN moodid SET DEFAULT nextval('public.mood_moodid_seq'::regclass);
 :   ALTER TABLE public.mood ALTER COLUMN moodid DROP DEFAULT;
       public          admin    false    215    214    215            �           2604    17404 !   popularcombinations combinationid    DEFAULT     �   ALTER TABLE ONLY public.popularcombinations ALTER COLUMN combinationid SET DEFAULT nextval('public.popularcombinations_combinationid_seq'::regclass);
 P   ALTER TABLE public.popularcombinations ALTER COLUMN combinationid DROP DEFAULT;
       public          admin    false    220    221    221            �           2604    17486    recommendationlog logid    DEFAULT     �   ALTER TABLE ONLY public.recommendationlog ALTER COLUMN logid SET DEFAULT nextval('public.recommendationlog_logid_seq'::regclass);
 F   ALTER TABLE public.recommendationlog ALTER COLUMN logid DROP DEFAULT;
       public          postgres    false    227    226    227            �           2604    17362    snack snackid    DEFAULT     n   ALTER TABLE ONLY public.snack ALTER COLUMN snackid SET DEFAULT nextval('public.snack_snackid_seq'::regclass);
 <   ALTER TABLE public.snack ALTER COLUMN snackid DROP DEFAULT;
       public          admin    false    216    217    217            >          0    17439    User 
   TABLE DATA           F   COPY public."User" (userid, username, passwordhash, role) FROM stdin;
    public          admin    false    223   RN       @          0    17467    blogpost 
   TABLE DATA           O   COPY public.blogpost (postid, authorid, title, content, createdat) FROM stdin;
    public          postgres    false    225   �N       :          0    17371    drink 
   TABLE DATA           R   COPY public.drink (drinkid, name, type, flavorprofile, moodid, photo) FROM stdin;
    public          admin    false    219   O       6          0    17347    mood 
   TABLE DATA           I   COPY public.mood (moodid, moodname, description, hybridmood) FROM stdin;
    public          admin    false    215   �P       <          0    17401    popularcombinations 
   TABLE DATA           _   COPY public.popularcombinations (combinationid, snackid, drinkid, popularitycount) FROM stdin;
    public          admin    false    221   Q       B          0    17483    recommendationlog 
   TABLE DATA           a   COPY public.recommendationlog (logid, userid, moodid, snackid, drinkid, "timestamp") FROM stdin;
    public          postgres    false    227   �Q       8          0    17359    snack 
   TABLE DATA           R   COPY public.snack (snackid, name, type, flavorprofile, moodid, photo) FROM stdin;
    public          admin    false    217   R       S           0    0    User_userid_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."User_userid_seq"', 8, true);
          public          admin    false    222            T           0    0    blogpost_postid_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.blogpost_postid_seq', 4, true);
          public          postgres    false    224            U           0    0    drink_drinkid_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.drink_drinkid_seq', 19, true);
          public          admin    false    218            V           0    0    mood_moodid_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mood_moodid_seq', 4, true);
          public          admin    false    214            W           0    0 %   popularcombinations_combinationid_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.popularcombinations_combinationid_seq', 15, true);
          public          admin    false    220            X           0    0    recommendationlog_logid_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.recommendationlog_logid_seq', 1, false);
          public          postgres    false    226            Y           0    0    snack_snackid_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.snack_snackid_seq', 23, true);
          public          admin    false    216            �           2606    17447    User User_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (userid);
 <   ALTER TABLE ONLY public."User" DROP CONSTRAINT "User_pkey";
       public            admin    false    223            �           2606    17475    blogpost blogpost_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.blogpost
    ADD CONSTRAINT blogpost_pkey PRIMARY KEY (postid);
 @   ALTER TABLE ONLY public.blogpost DROP CONSTRAINT blogpost_pkey;
       public            postgres    false    225            �           2606    17376    drink drink_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.drink
    ADD CONSTRAINT drink_pkey PRIMARY KEY (drinkid);
 :   ALTER TABLE ONLY public.drink DROP CONSTRAINT drink_pkey;
       public            admin    false    219            �           2606    17357    mood mood_moodname_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.mood
    ADD CONSTRAINT mood_moodname_key UNIQUE (moodname);
 @   ALTER TABLE ONLY public.mood DROP CONSTRAINT mood_moodname_key;
       public            admin    false    215            �           2606    17355    mood mood_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.mood
    ADD CONSTRAINT mood_pkey PRIMARY KEY (moodid);
 8   ALTER TABLE ONLY public.mood DROP CONSTRAINT mood_pkey;
       public            admin    false    215            �           2606    17407 ,   popularcombinations popularcombinations_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.popularcombinations
    ADD CONSTRAINT popularcombinations_pkey PRIMARY KEY (combinationid);
 V   ALTER TABLE ONLY public.popularcombinations DROP CONSTRAINT popularcombinations_pkey;
       public            admin    false    221            �           2606    17489 (   recommendationlog recommendationlog_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.recommendationlog
    ADD CONSTRAINT recommendationlog_pkey PRIMARY KEY (logid);
 R   ALTER TABLE ONLY public.recommendationlog DROP CONSTRAINT recommendationlog_pkey;
       public            postgres    false    227            �           2606    17364    snack snack_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.snack
    ADD CONSTRAINT snack_pkey PRIMARY KEY (snackid);
 :   ALTER TABLE ONLY public.snack DROP CONSTRAINT snack_pkey;
       public            admin    false    217            �           2606    17476    blogpost blogpost_authorid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.blogpost
    ADD CONSTRAINT blogpost_authorid_fkey FOREIGN KEY (authorid) REFERENCES public."User"(userid);
 I   ALTER TABLE ONLY public.blogpost DROP CONSTRAINT blogpost_authorid_fkey;
       public          postgres    false    3225    223    225            �           2606    17377    drink drink_moodid_fkey    FK CONSTRAINT     x   ALTER TABLE ONLY public.drink
    ADD CONSTRAINT drink_moodid_fkey FOREIGN KEY (moodid) REFERENCES public.mood(moodid);
 A   ALTER TABLE ONLY public.drink DROP CONSTRAINT drink_moodid_fkey;
       public          admin    false    3217    215    219            �           2606    17413 4   popularcombinations popularcombinations_drinkid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.popularcombinations
    ADD CONSTRAINT popularcombinations_drinkid_fkey FOREIGN KEY (drinkid) REFERENCES public.drink(drinkid);
 ^   ALTER TABLE ONLY public.popularcombinations DROP CONSTRAINT popularcombinations_drinkid_fkey;
       public          admin    false    219    221    3221            �           2606    17408 4   popularcombinations popularcombinations_snackid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.popularcombinations
    ADD CONSTRAINT popularcombinations_snackid_fkey FOREIGN KEY (snackid) REFERENCES public.snack(snackid);
 ^   ALTER TABLE ONLY public.popularcombinations DROP CONSTRAINT popularcombinations_snackid_fkey;
       public          admin    false    3219    221    217            �           2606    17505 0   recommendationlog recommendationlog_drinkid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.recommendationlog
    ADD CONSTRAINT recommendationlog_drinkid_fkey FOREIGN KEY (drinkid) REFERENCES public.drink(drinkid);
 Z   ALTER TABLE ONLY public.recommendationlog DROP CONSTRAINT recommendationlog_drinkid_fkey;
       public          postgres    false    3221    227    219            �           2606    17495 /   recommendationlog recommendationlog_moodid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.recommendationlog
    ADD CONSTRAINT recommendationlog_moodid_fkey FOREIGN KEY (moodid) REFERENCES public.mood(moodid);
 Y   ALTER TABLE ONLY public.recommendationlog DROP CONSTRAINT recommendationlog_moodid_fkey;
       public          postgres    false    3217    215    227            �           2606    17500 0   recommendationlog recommendationlog_snackid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.recommendationlog
    ADD CONSTRAINT recommendationlog_snackid_fkey FOREIGN KEY (snackid) REFERENCES public.snack(snackid);
 Z   ALTER TABLE ONLY public.recommendationlog DROP CONSTRAINT recommendationlog_snackid_fkey;
       public          postgres    false    217    227    3219            �           2606    17490 /   recommendationlog recommendationlog_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.recommendationlog
    ADD CONSTRAINT recommendationlog_userid_fkey FOREIGN KEY (userid) REFERENCES public."User"(userid);
 Y   ALTER TABLE ONLY public.recommendationlog DROP CONSTRAINT recommendationlog_userid_fkey;
       public          postgres    false    3225    227    223            �           2606    17365    snack snack_moodid_fkey    FK CONSTRAINT     x   ALTER TABLE ONLY public.snack
    ADD CONSTRAINT snack_moodid_fkey FOREIGN KEY (moodid) REFERENCES public.mood(moodid);
 A   ALTER TABLE ONLY public.snack DROP CONSTRAINT snack_moodid_fkey;
       public          admin    false    217    215    3217            >   (   x���LIMK,�)�/-N-�,,O-*�442�q�b���� ۇ
      @   �   x�%��
�0���S�А?!�Y���x��j+B�����u�N3|�UR�a"��H�N�@ p�p������(o}l���l�(���y�C�V�K-��IE��]xe�N�����&�!G��Ҥ�6��Z��&�      :   �  x�uR�n�0}�? �J�����[ӕ�J}Y)ra
���i��w$A�*^0s87�~8S���R���Z��{���aY�����Pg*�������r��sd��^��������Z¯S���Qb,Ö��aCޣ�u�7Ǳ�`�V�u�p�%%���,:� z�K��G�wRxC%Ħ��Loɻ�����o������3t02�q�E'��5��@�'l!�L2[�s���I�����-A��O�z�s¥�_��(�ŤCS��������[71 '!�2=��(�G�ؚt�<&Xh ��҆��/����T��U@��͙��8��#e���d(�N�Sy�Z0u	/d�-%H]�D`��58��֏��ᾩ6�QC_�6Pj7����6�'��%m_�;�!�-��DY�tj~��a����R�I]��      6   �   x�U�;�0���>�"�q�ܣ��ĕ�V�}�P�@|�/AS�Vi.�,�o`����{%TC��������c��ɐl;gp�&�]�B�$a"���2��ڙ�:ʌ��r�Ž���\��yo�	�ɟt��9ZY��j���c� �Kx      <   U   x�%̱�@B���Hk���r��as��"i\�ް|`��+�`Gl��30����?sa:�yc�b>��La���"��D�      B      x������ � �      8   �  x�}S�n�0>����Zv��+�QmD���R	9�����>}�6d���7�����@��J�B"쎈���	T~Z��WS�k�5V���4��/m��!:7����< p>A��� ��	#�a�nH\*�,zTg�FVlIZ����ڨ���ޡn_t����6�-<jJ��~��E�HU�o2�����U�G�iSȵU�+��yy�aC�
'����.��N�P娞�3^�$tO����'�ϥ��0ѓ��
�F��3��+��u�5Y���š�v�ޙ��W�\�H�^���<�b�K6�Y}T�n�#�e�P���n[ȲoK��Gʓ��zt'���fԼAB�>�5+‼�D���9��-n�� �!������!�Y7.d��¢���?��oɒ;����o!w��y�W��BvT����G���	�V�aj�?�o#�)|Ǻ��\J�텪?��n�{�ҏS�?��c<xßk��_B     