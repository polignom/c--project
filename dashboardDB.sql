PGDMP     3    *                {            hospitalDataBase    15.5    15.5 ;    U           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            V           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            W           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            X           1262    16398    hospitalDataBase    DATABASE     �   CREATE DATABASE "hospitalDataBase" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
 "   DROP DATABASE "hospitalDataBase";
                postgres    false                        2615    16399 
   hospitalDB    SCHEMA        CREATE SCHEMA "hospitalDB";
    DROP SCHEMA "hospitalDB";
                postgres    false            �            1255    16659 	   archive()    FUNCTION     �  CREATE FUNCTION "hospitalDB".archive() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF 
		NEW."дата_выписки" <> OLD."дата_выписки" 
		AND 
		NEW."дата_выписки" <=CURRENT_DATE
		THEN
            INSERT INTO "hospitalDB"."архив_медкарт" ("медкартаАрхив")
            VALUES (OLD."id_медкарта");
        RETURN NEW;
		END IF;
    END;
	$$;
 &   DROP FUNCTION "hospitalDB".archive();
    
   hospitalDB          postgres    false    5            �            1255    16652 ,   госпитализацияСегодня()    FUNCTION     #  CREATE FUNCTION "hospitalDB"."госпитализацияСегодня"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW."дата_госпитализации" := CURRENT_DATE; -- Устанавливаем текущую дату при вставке
  RETURN NEW;
END;
$$;
 K   DROP FUNCTION "hospitalDB"."госпитализацияСегодня"();
    
   hospitalDB          postgres    false    5            �            1259    16641    архив_медкарт    TABLE     �   CREATE TABLE "hospitalDB"."архив_медкарт" (
    "id_архивнаяЗапись" integer NOT NULL,
    "медкартаАрхив" integer
);
 5   DROP TABLE "hospitalDB"."архив_медкарт";
    
   hospitalDB         heap    postgres    false    5            �            1259    16640 =   архив_медкарт_id_архивнаяЗапись_seq    SEQUENCE     �   CREATE SEQUENCE "hospitalDB"."архив_медкарт_id_архивнаяЗапись_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 \   DROP SEQUENCE "hospitalDB"."архив_медкарт_id_архивнаяЗапись_seq";
    
   hospitalDB          postgres    false    5    226            Y           0    0 =   архив_медкарт_id_архивнаяЗапись_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE "hospitalDB"."архив_медкарт_id_архивнаяЗапись_seq" OWNED BY "hospitalDB"."архив_медкарт"."id_архивнаяЗапись";
       
   hospitalDB          postgres    false    225            �            1259    16422    врач    TABLE     5  CREATE TABLE "hospitalDB"."врач" (
    "id_врач" integer NOT NULL,
    "ФИО" character varying(100),
    "дата_рождения" date,
    "стаж" smallint,
    "специальности_id" integer,
    "отделение_id" integer,
    "трудовой_договор_id" integer
);
 $   DROP TABLE "hospitalDB"."врач";
    
   hospitalDB         heap    postgres    false    5            �            1259    16452    диагнозыМКБ    TABLE     �   CREATE TABLE "hospitalDB"."диагнозыМКБ" (
    "id_диагнозыМКБ" integer NOT NULL,
    "номерМКБ" integer,
    "расшифровка" text
);
 2   DROP TABLE "hospitalDB"."диагнозыМКБ";
    
   hospitalDB         heap    postgres    false    5            �            1259    16459    медкарта    TABLE     T  CREATE TABLE "hospitalDB"."медкарта" (
    "id_медкарта" integer NOT NULL,
    "дата_госпитализации" date,
    "дата_выписки" date,
    "врач_id" integer,
    "пациент_id" integer,
    "диагноз_id" integer,
    "процедуры_id" integer,
    "палата_id" integer
);
 ,   DROP TABLE "hospitalDB"."медкарта";
    
   hospitalDB         heap    postgres    false    5            �            1259    16427    отделение    TABLE     E  CREATE TABLE "hospitalDB"."отделение" (
    "id_отделение" integer NOT NULL,
    "название_отделения" character varying(100),
    "заведующий_ФИО" character varying(100),
    "корпус" character(100),
    "этаж" smallint,
    "телефон" character varying(15)
);
 .   DROP TABLE "hospitalDB"."отделение";
    
   hospitalDB         heap    postgres    false    5            �            1259    16432    палата    TABLE     �   CREATE TABLE "hospitalDB"."палата" (
    "id_палата" integer NOT NULL,
    "всего_мест" smallint,
    "отделение_id" integer,
    "пол_id" integer
);
 (   DROP TABLE "hospitalDB"."палата";
    
   hospitalDB         heap    postgres    false    5            �            1259    16442    пациент    TABLE     -  CREATE TABLE "hospitalDB"."пациент" (
    "id_пациент" integer NOT NULL,
    "ФИО_пациента" character varying(110),
    "дата_рождения" date,
    "адрес_регистрации" character varying(200),
    "полисОМС" bigint,
    "пол_id" integer
);
 *   DROP TABLE "hospitalDB"."пациент";
    
   hospitalDB         heap    postgres    false    5            �            1259    16437    пол    TABLE     m   CREATE TABLE "hospitalDB"."пол" (
    "id_пол" integer NOT NULL,
    "пол" character varying(20)
);
 "   DROP TABLE "hospitalDB"."пол";
    
   hospitalDB         heap    postgres    false    5            �            1259    16447    процедуры    TABLE     �   CREATE TABLE "hospitalDB"."процедуры" (
    "id_процедуры" integer NOT NULL,
    "название_процедуры" character varying(50),
    "тип_процедуры" character varying(50)
);
 .   DROP TABLE "hospitalDB"."процедуры";
    
   hospitalDB         heap    postgres    false    5            �            1259    16548    свободныеПалаты    VIEW     �  CREATE VIEW "hospitalDB"."свободныеПалаты" AS
 SELECT "палата"."id_палата",
    "палата"."всего_мест",
    "палата"."пол_id",
    count("медкарта"."id_медкарта") AS "занято",
    ("палата"."всего_мест" - count("медкарта"."id_медкарта")) AS "свободно"
   FROM ("hospitalDB"."палата"
     LEFT JOIN "hospitalDB"."медкарта" ON ((("палата"."id_палата" = "медкарта"."палата_id") AND ("медкарта"."дата_госпитализации" >= '2023-01-01'::date) AND (("медкарта"."дата_выписки" IS NULL) OR ("медкарта"."дата_выписки" <= '2023-08-01'::date)))))
  WHERE ("палата"."пол_id" = 1)
  GROUP BY "палата"."id_палата", "палата"."всего_мест", "палата"."пол_id";
 9   DROP VIEW "hospitalDB"."свободныеПалаты";
    
   hospitalDB          postgres    false    218    223    223    223    218    218    223    5            �            1259    16400    специальности    TABLE     �   CREATE TABLE "hospitalDB"."специальности" (
    "id_специальности" integer NOT NULL,
    "название_специальности" character varying
);
 6   DROP TABLE "hospitalDB"."специальности";
    
   hospitalDB         heap    postgres    false    5            �            1259    16412    трудовой_договор    TABLE     �   CREATE TABLE "hospitalDB"."трудовой_договор" (
    "id_трудовой_договор" integer NOT NULL,
    "дата_приема" date,
    "дата_увольнения" date
);
 ;   DROP TABLE "hospitalDB"."трудовой_договор";
    
   hospitalDB         heap    postgres    false    5            �           2604    16644 9   архив_медкарт id_архивнаяЗапись    DEFAULT     �   ALTER TABLE ONLY "hospitalDB"."архив_медкарт" ALTER COLUMN "id_архивнаяЗапись" SET DEFAULT nextval('"hospitalDB"."архив_медкарт_id_архивнаяЗапись_seq"'::regclass);
 r   ALTER TABLE "hospitalDB"."архив_медкарт" ALTER COLUMN "id_архивнаяЗапись" DROP DEFAULT;
    
   hospitalDB          postgres    false    225    226    226            R          0    16641    архив_медкарт 
   TABLE DATA           |   COPY "hospitalDB"."архив_медкарт" ("id_архивнаяЗапись", "медкартаАрхив") FROM stdin;
 
   hospitalDB          postgres    false    226   �^       I          0    16422    врач 
   TABLE DATA           �   COPY "hospitalDB"."врач" ("id_врач", "ФИО", "дата_рождения", "стаж", "специальности_id", "отделение_id", "трудовой_договор_id") FROM stdin;
 
   hospitalDB          postgres    false    216   _       O          0    16452    диагнозыМКБ 
   TABLE DATA           �   COPY "hospitalDB"."диагнозыМКБ" ("id_диагнозыМКБ", "номерМКБ", "расшифровка") FROM stdin;
 
   hospitalDB          postgres    false    222   �`       P          0    16459    медкарта 
   TABLE DATA           �   COPY "hospitalDB"."медкарта" ("id_медкарта", "дата_госпитализации", "дата_выписки", "врач_id", "пациент_id", "диагноз_id", "процедуры_id", "палата_id") FROM stdin;
 
   hospitalDB          postgres    false    223   ta       J          0    16427    отделение 
   TABLE DATA           �   COPY "hospitalDB"."отделение" ("id_отделение", "название_отделения", "заведующий_ФИО", "корпус", "этаж", "телефон") FROM stdin;
 
   hospitalDB          postgres    false    217   Qb       K          0    16432    палата 
   TABLE DATA           ~   COPY "hospitalDB"."палата" ("id_палата", "всего_мест", "отделение_id", "пол_id") FROM stdin;
 
   hospitalDB          postgres    false    218   c       M          0    16442    пациент 
   TABLE DATA           �   COPY "hospitalDB"."пациент" ("id_пациент", "ФИО_пациента", "дата_рождения", "адрес_регистрации", "полисОМС", "пол_id") FROM stdin;
 
   hospitalDB          postgres    false    220   oc       L          0    16437    пол 
   TABLE DATA           ?   COPY "hospitalDB"."пол" ("id_пол", "пол") FROM stdin;
 
   hospitalDB          postgres    false    219   �e       N          0    16447    процедуры 
   TABLE DATA           �   COPY "hospitalDB"."процедуры" ("id_процедуры", "название_процедуры", "тип_процедуры") FROM stdin;
 
   hospitalDB          postgres    false    221   f       G          0    16400    специальности 
   TABLE DATA           �   COPY "hospitalDB"."специальности" ("id_специальности", "название_специальности") FROM stdin;
 
   hospitalDB          postgres    false    214   �f       H          0    16412    трудовой_договор 
   TABLE DATA           �   COPY "hospitalDB"."трудовой_договор" ("id_трудовой_договор", "дата_приема", "дата_увольнения") FROM stdin;
 
   hospitalDB          postgres    false    215   *g       Z           0    0 =   архив_медкарт_id_архивнаяЗапись_seq    SEQUENCE SET     s   SELECT pg_catalog.setval('"hospitalDB"."архив_медкарт_id_архивнаяЗапись_seq"', 5, true);
       
   hospitalDB          postgres    false    225            �           2606    16646 8   архив_медкарт архив_медкарт_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."архив_медкарт"
    ADD CONSTRAINT "архив_медкарт_pkey" PRIMARY KEY ("id_архивнаяЗапись");
 l   ALTER TABLE ONLY "hospitalDB"."архив_медкарт" DROP CONSTRAINT "архив_медкарт_pkey";
    
   hospitalDB            postgres    false    226            �           2606    16426    врач врач_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY "hospitalDB"."врач"
    ADD CONSTRAINT "врач_pkey" PRIMARY KEY ("id_врач");
 J   ALTER TABLE ONLY "hospitalDB"."врач" DROP CONSTRAINT "врач_pkey";
    
   hospitalDB            postgres    false    216            �           2606    16458 2   диагнозыМКБ диагнозыМКБ_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."диагнозыМКБ"
    ADD CONSTRAINT "диагнозыМКБ_pkey" PRIMARY KEY ("id_диагнозыМКБ");
 f   ALTER TABLE ONLY "hospitalDB"."диагнозыМКБ" DROP CONSTRAINT "диагнозыМКБ_pkey";
    
   hospitalDB            postgres    false    222            �           2606    16463 &   медкарта медкарта_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."медкарта"
    ADD CONSTRAINT "медкарта_pkey" PRIMARY KEY ("id_медкарта");
 Z   ALTER TABLE ONLY "hospitalDB"."медкарта" DROP CONSTRAINT "медкарта_pkey";
    
   hospitalDB            postgres    false    223            �           2606    16431 *   отделение отделение_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."отделение"
    ADD CONSTRAINT "отделение_pkey" PRIMARY KEY ("id_отделение");
 ^   ALTER TABLE ONLY "hospitalDB"."отделение" DROP CONSTRAINT "отделение_pkey";
    
   hospitalDB            postgres    false    217            �           2606    16436    палата палата_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY "hospitalDB"."палата"
    ADD CONSTRAINT "палата_pkey" PRIMARY KEY ("id_палата");
 R   ALTER TABLE ONLY "hospitalDB"."палата" DROP CONSTRAINT "палата_pkey";
    
   hospitalDB            postgres    false    218            �           2606    16446 "   пациент пациент_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY "hospitalDB"."пациент"
    ADD CONSTRAINT "пациент_pkey" PRIMARY KEY ("id_пациент");
 V   ALTER TABLE ONLY "hospitalDB"."пациент" DROP CONSTRAINT "пациент_pkey";
    
   hospitalDB            postgres    false    220            �           2606    16441    пол пол_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY "hospitalDB"."пол"
    ADD CONSTRAINT "пол_pkey" PRIMARY KEY ("id_пол");
 F   ALTER TABLE ONLY "hospitalDB"."пол" DROP CONSTRAINT "пол_pkey";
    
   hospitalDB            postgres    false    219            �           2606    16451 *   процедуры процедуры_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."процедуры"
    ADD CONSTRAINT "процедуры_pkey" PRIMARY KEY ("id_процедуры");
 ^   ALTER TABLE ONLY "hospitalDB"."процедуры" DROP CONSTRAINT "процедуры_pkey";
    
   hospitalDB            postgres    false    221            �           2606    16406 :   специальности специальности_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."специальности"
    ADD CONSTRAINT "специальности_pkey" PRIMARY KEY ("id_специальности");
 n   ALTER TABLE ONLY "hospitalDB"."специальности" DROP CONSTRAINT "специальности_pkey";
    
   hospitalDB            postgres    false    214            �           2606    16416 D   трудовой_договор трудовой_договор_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."трудовой_договор"
    ADD CONSTRAINT "трудовой_договор_pkey" PRIMARY KEY ("id_трудовой_договор");
 x   ALTER TABLE ONLY "hospitalDB"."трудовой_договор" DROP CONSTRAINT "трудовой_договор_pkey";
    
   hospitalDB            postgres    false    215            �           2620    16662     медкарта archive_trigger    TRIGGER     �   CREATE TRIGGER archive_trigger AFTER UPDATE ON "hospitalDB"."медкарта" FOR EACH ROW EXECUTE FUNCTION "hospitalDB".archive();
 A   DROP TRIGGER archive_trigger ON "hospitalDB"."медкарта";
    
   hospitalDB          postgres    false    239    223            �           2620    16653 &   медкарта before_insert_medcard    TRIGGER     �   CREATE TRIGGER before_insert_medcard BEFORE INSERT ON "hospitalDB"."медкарта" FOR EACH ROW EXECUTE FUNCTION "hospitalDB"."госпитализацияСегодня"();
 G   DROP TRIGGER before_insert_medcard ON "hospitalDB"."медкарта";
    
   hospitalDB          postgres    false    227    223            �           2606    16514    медкарта fk_врач    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."медкарта"
    ADD CONSTRAINT "fk_врач" FOREIGN KEY ("врач_id") REFERENCES "hospitalDB"."врач"("id_врач") NOT VALID;
 P   ALTER TABLE ONLY "hospitalDB"."медкарта" DROP CONSTRAINT "fk_врач";
    
   hospitalDB          postgres    false    223    3225    216            �           2606    16524 "   медкарта fk_диагноз    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."медкарта"
    ADD CONSTRAINT "fk_диагноз" FOREIGN KEY ("диагноз_id") REFERENCES "hospitalDB"."диагнозыМКБ"("id_диагнозыМКБ") NOT VALID;
 V   ALTER TABLE ONLY "hospitalDB"."медкарта" DROP CONSTRAINT "fk_диагноз";
    
   hospitalDB          postgres    false    222    223    3237            �           2606    16647 7   архив_медкарт fk_медкартаАрхив    FK CONSTRAINT     	  ALTER TABLE ONLY "hospitalDB"."архив_медкарт"
    ADD CONSTRAINT "fk_медкартаАрхив" FOREIGN KEY ("медкартаАрхив") REFERENCES "hospitalDB"."медкарта"("id_медкарта") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 k   ALTER TABLE ONLY "hospitalDB"."архив_медкарт" DROP CONSTRAINT "fk_медкартаАрхив";
    
   hospitalDB          postgres    false    226    223    3239            �           2606    16489    врач fk_отделение    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."врач"
    ADD CONSTRAINT "fk_отделение" FOREIGN KEY ("отделение_id") REFERENCES "hospitalDB"."отделение"("id_отделение") NOT VALID;
 R   ALTER TABLE ONLY "hospitalDB"."врач" DROP CONSTRAINT "fk_отделение";
    
   hospitalDB          postgres    false    217    3227    216            �           2606    16499 "   палата fk_отделение    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."палата"
    ADD CONSTRAINT "fk_отделение" FOREIGN KEY ("отделение_id") REFERENCES "hospitalDB"."отделение"("id_отделение") NOT VALID;
 V   ALTER TABLE ONLY "hospitalDB"."палата" DROP CONSTRAINT "fk_отделение";
    
   hospitalDB          postgres    false    217    218    3227            �           2606    16538     медкарта fk_палата    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."медкарта"
    ADD CONSTRAINT "fk_палата" FOREIGN KEY ("палата_id") REFERENCES "hospitalDB"."палата"("id_палата") NOT VALID;
 T   ALTER TABLE ONLY "hospitalDB"."медкарта" DROP CONSTRAINT "fk_палата";
    
   hospitalDB          postgres    false    3229    218    223            �           2606    16519 "   медкарта fk_пациент    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."медкарта"
    ADD CONSTRAINT "fk_пациент" FOREIGN KEY ("пациент_id") REFERENCES "hospitalDB"."пациент"("id_пациент") NOT VALID;
 V   ALTER TABLE ONLY "hospitalDB"."медкарта" DROP CONSTRAINT "fk_пациент";
    
   hospitalDB          postgres    false    223    3233    220            �           2606    16504    палата fk_пол    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."палата"
    ADD CONSTRAINT "fk_пол" FOREIGN KEY ("пол_id") REFERENCES "hospitalDB"."пол"("id_пол") NOT VALID;
 J   ALTER TABLE ONLY "hospitalDB"."палата" DROP CONSTRAINT "fk_пол";
    
   hospitalDB          postgres    false    218    219    3231            �           2606    16509    пациент fk_пол    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."пациент"
    ADD CONSTRAINT "fk_пол" FOREIGN KEY ("пол_id") REFERENCES "hospitalDB"."пол"("id_пол") NOT VALID;
 L   ALTER TABLE ONLY "hospitalDB"."пациент" DROP CONSTRAINT "fk_пол";
    
   hospitalDB          postgres    false    219    220    3231            �           2606    16529 &   медкарта fk_процедуры    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."медкарта"
    ADD CONSTRAINT "fk_процедуры" FOREIGN KEY ("процедуры_id") REFERENCES "hospitalDB"."процедуры"("id_процедуры") NOT VALID;
 Z   ALTER TABLE ONLY "hospitalDB"."медкарта" DROP CONSTRAINT "fk_процедуры";
    
   hospitalDB          postgres    false    3235    221    223            �           2606    16484 &   врач fk_специальности    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."врач"
    ADD CONSTRAINT "fk_специальности" FOREIGN KEY ("специальности_id") REFERENCES "hospitalDB"."специальности"("id_специальности") NOT VALID;
 Z   ALTER TABLE ONLY "hospitalDB"."врач" DROP CONSTRAINT "fk_специальности";
    
   hospitalDB          postgres    false    216    3221    214            �           2606    16494 *   врач fk_трудовойДоговор    FK CONSTRAINT     �   ALTER TABLE ONLY "hospitalDB"."врач"
    ADD CONSTRAINT "fk_трудовойДоговор" FOREIGN KEY ("трудовой_договор_id") REFERENCES "hospitalDB"."трудовой_договор"("id_трудовой_договор") NOT VALID;
 ^   ALTER TABLE ONLY "hospitalDB"."врач" DROP CONSTRAINT "fk_трудовойДоговор";
    
   hospitalDB          postgres    false    216    3223    215            R      x�3�4����� �"      I   �  x�mR[N�0�^��0��rr�?Hm�O���C���WX߈�J�P�����̮#^�7aīp�=�5/Äw|�4�#�C�p��5�5�66��RF99�?�@��1u�y����a���:����:�����TN|��1�܅IE�����S͏8���[i����8g���(W�`�u@�q�@��@=��-�R��I���]�J�̀�G��?��l�`��%w"�z���RU�K���u	g�=��0����h�:�̱�U�?K��X$0/4����_�15є����(ͧɀ��M�CHiP[
@Ԫ�����".l4�AB+ڡUdaJ�6�YJ�e<�U�.�,@�c�3Ґ�-��xq�Yu~����r�      O   �   x�UO��0|��H��	��!����V"`r��lG�+y��q*�p�I+�cЋ�&��/x@�;�����q�0`Ƙ��L_or�s!x�Hl�W��z&I�6�VĞ��r�6�W!qb�-�~��,D�`:�x%���i
8�Y�uka~�Gv�c�{L(����f�3��)3���Q�х�7�`0ۥ1����      P   �   x�U���0C��.)L��D'��s�V�=x�i�fL,Y�R�`��)C�@L�w�R �d(�2�웸,B�� )R��9~p�Ĩ�R�m{�,py��z�ӯb��Tt�|�$�we�4n�{<���ƳI����R����A��r�,�i���y�����B��{�E�����ۼ�zЦ7�D�?(��ì'3m�����mL��~��וQv      J   �   x���M
�0���)r��M��]<LU�m]"�x�Ph�i�0���*(�֒E�$�o�J�Ç<JNuX1��^pĕQ��R��O�ѣ��sgɫ.q7^�B��#fb�l̥�AbX�u����w/�cǖ�:6�R����O{�hȥ�P�Em��_ޕNc�S>6�80/��π�����,16I���Rw��T      K   @   x����0�7S�$i�]������D�(+��Z�A/�֗<��ۊu�MB��]$W      M   R  x�mT[n�@����h~�^� RS)��6��D�|����@�#�����q��`	��q�=��Q4�7Z��hO����v��b�Z_�L�5|fF/i��퐦r�I1o�ˋ���2�UtK[Z�&���jL��`0C��\��}�}fpnJ{�����a4�_8���L�JUe�rFR6q
��a���>�z@�0��p��j�g�f�+��g����%��]��uj�[^���%h�~c	�hP ����#�^"�(ZYf�e��/Z��G�p��&���/=���?6�~�a�廤�IX�Aڜ�ؠ�0�S�3
 E��P�T}�t/A�����Vk�i�6W��B7�{�K/�d-�"Zk��*�B��t�1���,�x�z:�����s��`����+v˾�Z�)��BQp+	���" �Z'���>I����d�%@��A�Ç���_{��Q�����%G=a����}�	���j�KZka��1��j�gBm�U��5����#��1��}�
�DߡG�w& u!G|�a�,�Gޚ��������KZ�x�B��=Q?I8<�4L���]�      L   -   x�3估�b�m/캰��N.#��.l��,�(���� ۊ      N   �   x�u���0D��*R�j(ƀ�HҊ11�@L�1�k�;ovvl�DP��{tzĭB�|�j�w#�8�㎀���C��P�V7�:���-��M�8��,��Nw\Rw�܁�lTZ��8�]�+2D�re�Y�4X�<����\{ �;J�r$"/���      G   [   x�M���0߻� quC1!�~�D�ق��ßۭ �@`O�2Nl���<��
��H���D��_���tL'��y�����z�E�      H   o   x�E���0��.,DŎ�]���"���)��͝6螸
�Ct�&��W���;O�J%ڮJE��Y����0_ѻ+����B����|���ѻ����=��}ܜ�*�     