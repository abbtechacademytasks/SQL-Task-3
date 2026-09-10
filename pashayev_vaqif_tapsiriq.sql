SET client_min_messages = WARNING;

DROP SCHEMA IF EXISTS akademiya_raw CASCADE;
DROP SCHEMA IF EXISTS nf1 CASCADE;
DROP SCHEMA IF EXISTS nf2 CASCADE;
DROP SCHEMA IF EXISTS norm_demo CASCADE;
DROP SCHEMA IF EXISTS akademiya_online CASCADE;

CREATE SCHEMA akademiya_raw;
CREATE SCHEMA nf1;
CREATE SCHEMA nf2;
CREATE SCHEMA norm_demo;
CREATE SCHEMA akademiya_online;

-- Ilkin, normallasdirilmamis cedvel. Telefonlar ve muellim dilleri
-- vergulle ayrilmis metn kimi saxlanildigi ucun 1NF pozulur.
CREATE TABLE akademiya_raw.kurs_qeydiyyat (
    telebe_id VARCHAR(10) NOT NULL,
    telebe_ad VARCHAR(100) NOT NULL,
    dogum_tarixi DATE NOT NULL,
    telefonlar TEXT,
    kurs_kod VARCHAR(10) NOT NULL,
    kurs_ad VARCHAR(100) NOT NULL,
    kurs_saat INTEGER NOT NULL CHECK (kurs_saat > 0),
    qiymet NUMERIC(10, 2) NOT NULL CHECK (qiymet > 0),
    fenn_kod VARCHAR(10) NOT NULL,
    fenn_ad VARCHAR(100) NOT NULL,
    muellim_id VARCHAR(10) NOT NULL,
    muellim_ad VARCHAR(100) NOT NULL,
    muellim_email VARCHAR(150) NOT NULL,
    muellim_dilleri TEXT,
    otaq_no VARCHAR(10) NOT NULL,
    otaq_tutum INTEGER NOT NULL CHECK (otaq_tutum > 0),
    filial_kod VARCHAR(10) NOT NULL,
    filial_unvan VARCHAR(200) NOT NULL,
    seher VARCHAR(50) NOT NULL,
    qeyd_tarixi DATE NOT NULL,
    odenis NUMERIC(10, 2) NOT NULL CHECK (odenis >= 0),
    imtahan_bali INTEGER CHECK (imtahan_bali BETWEEN 0 AND 100),
    CONSTRAINT pk_raw_kurs_qeydiyyat PRIMARY KEY (telebe_id, kurs_kod)
);

INSERT INTO akademiya_raw.kurs_qeydiyyat (
    telebe_id, telebe_ad, dogum_tarixi, telefonlar,
    kurs_kod, kurs_ad, kurs_saat, qiymet, fenn_kod, fenn_ad,
    muellim_id, muellim_ad, muellim_email, muellim_dilleri,
    otaq_no, otaq_tutum, filial_kod, filial_unvan, seher,
    qeyd_tarixi, odenis, imtahan_bali
)
VALUES
    ('T-01', 'Aysel Məmmədova', DATE '2001-04-12', '055-111-22-33, 070-111-22-33',
     'SQL-101', 'SQL Əsasları', 40, 350, 'F-SQL', 'Verilənlər Bazaları',
     'M-05', 'Rəşad Quliyev', 'reshad@akademiya.az', 'Azərbaycan, İngilis, Rus',
     'A-201', 25, 'F-01', 'Bakı, Nizami küç. 12', 'Bakı', DATE '2025-02-10', 350, 92),
    ('T-01', 'Aysel Məmmədova', DATE '2001-04-12', '055-111-22-33, 070-111-22-33',
     'PYT-201', 'Python Başlanğıc', 60, 500, 'F-PYT', 'Proqramlaşdırma',
     'M-07', 'Nigar Əliyeva', 'nigar@akademiya.az', 'Azərbaycan, İngilis',
     'A-305', 30, 'F-01', 'Bakı, Nizami küç. 12', 'Bakı', DATE '2025-02-12', 500, 78),
    ('T-02', 'Elvin Hüseynov', DATE '1999-11-03', '051-777-88-99',
     'SQL-101', 'SQL Əsasları', 40, 350, 'F-SQL', 'Verilənlər Bazaları',
     'M-05', 'Rəşad Quliyev', 'reshad@akademiya.az', 'Azərbaycan, İngilis, Rus',
     'A-201', 25, 'F-01', 'Bakı, Nizami küç. 12', 'Bakı', DATE '2025-02-15', 350, 65),
    ('T-03', 'Nigar Səfərova', DATE '2003-02-20', '070-222-33-44, 055-222-33-44',
     'DSC-301', 'Data Science', 80, 700, 'F-DSC', 'Data Science',
     'M-09', 'Tural Abbasov', 'tural@akademiya.az', 'Azərbaycan',
     'B-410', 18, 'F-02', 'Gəncə, Atatürk pr. 5', 'Gəncə', DATE '2025-03-01', 700, 88),
    ('T-05', 'Leyla Orucova', DATE '2002-09-30', NULL,
     'SQL-101', 'SQL Əsasları', 40, 350, 'F-SQL', 'Verilənlər Bazaları',
     'M-05', 'Rəşad Quliyev', 'reshad@akademiya.az', 'Azərbaycan, İngilis, Rus',
     'A-201', 25, 'F-01', 'Bakı, Nizami küç. 12', 'Bakı', DATE '2025-02-18', 350, NULL),
    ('T-02', 'Elvin Hüseynov', DATE '1999-11-03', '051-777-88-99',
     'PYT-201', 'Python Başlanğıc', 60, 500, 'F-PYT', 'Proqramlaşdırma',
     'M-07', 'Nigar Əliyeva', 'nigar@akademiya.az', 'Azərbaycan, İngilis',
     'B-305', 22, 'F-02', 'Gəncə, Atatürk pr. 5', 'Gəncə', DATE '2025-03-05', 500, 54),
    ('T-03', 'Nigar Səfərova', DATE '2003-02-20', '070-222-33-44, 055-222-33-44',
     'SQL-202', 'Ətraflı SQL', 50, 450, 'F-SQL', 'Verilənlər Bazaları',
     'M-11', 'Aygün Vəliyeva', 'aygun@akademiya.az', 'Azərbaycan, Rus',
     'B-305', 22, 'F-02', 'Gəncə, Atatürk pr. 5', 'Gəncə', DATE '2025-03-10', 450, 71);

-- ===== Tapşırıq A1 =====
-- Izah (a): telefonlar ve muellim_dilleri sutunlarinda bir xanada
-- bir nece deyer saxlanilir. Vergulle ayrilan siyahi atomik deyil,
-- ona gore bu iki sutun 1NF-i pozur.
--
-- Izah (c): INSERT anomaliyasi - telebesi olmayan PYT-305 kursunu bu
-- cedvele ayrica yazmaq olmur. UPDATE anomaliyasi - M-05-in e-poctu
-- onun her qeydiyyat setrinde deyishmelidir. DELETE anomaliyasi -
-- T-03-un DSC-301 qeydiyyati silinse, kurs ve muellim melumati da itir.
--
-- Izah (d): PostgreSQL TEXT[] ve JSONB-ni bir sutun deyeri kimi qebul
-- etdiyi ucun fiziki baximdan atomik sayila biler. Lakin telefon kimi
-- ayrica axtarilan, UNIQUE qaydasi ve elaqesi olan faktlar ucun massiv
-- mentiqi 1NF ruhuna uygun deyil. Massiv yalniz elementler ayrica elaqe,
-- constraint ve tez-tez axtarish teleb etmedikde praktik ola biler.

CREATE TABLE nf1.kurs_qeydiyyat_1nf (
    qeydiyyat_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    telebe_id VARCHAR(10) NOT NULL,
    telebe_ad VARCHAR(100) NOT NULL,
    dogum_tarixi DATE NOT NULL,
    kurs_kodu VARCHAR(10) NOT NULL,
    kurs_adi VARCHAR(100) NOT NULL,
    kurs_saati INTEGER NOT NULL CHECK (kurs_saati > 0),
    qiymet NUMERIC(10, 2) NOT NULL CHECK (qiymet > 0),
    fenn_kodu VARCHAR(10) NOT NULL,
    fenn_adi VARCHAR(100) NOT NULL,
    muellim_id VARCHAR(10) NOT NULL,
    muellim_adi VARCHAR(100) NOT NULL,
    muellim_email VARCHAR(150) NOT NULL,
    otaq_no VARCHAR(10) NOT NULL,
    otaq_tutumu INTEGER NOT NULL CHECK (otaq_tutumu > 0),
    filial_kodu VARCHAR(10) NOT NULL,
    filial_unvani VARCHAR(200) NOT NULL,
    seher VARCHAR(50) NOT NULL,
    qeydiyyat_tarixi DATE NOT NULL,
    odenis NUMERIC(10, 2) NOT NULL CHECK (odenis >= 0),
    imtahan_bali INTEGER CHECK (imtahan_bali BETWEEN 0 AND 100),
    CONSTRAINT uq_nf1_telebe_kurs UNIQUE (telebe_id, kurs_kodu)
);

CREATE TABLE nf1.qeydiyyat_telefon_1nf (
    qeydiyyat_id BIGINT NOT NULL,
    telefon VARCHAR(20) NOT NULL CHECK (BTRIM(telefon) <> ''),
    CONSTRAINT pk_nf1_qeydiyyat_telefon PRIMARY KEY (qeydiyyat_id, telefon),
    CONSTRAINT fk_nf1_telefon_qeydiyyat FOREIGN KEY (qeydiyyat_id)
        REFERENCES nf1.kurs_qeydiyyat_1nf (qeydiyyat_id)
        ON DELETE CASCADE
);

CREATE TABLE nf1.qeydiyyat_muellim_dil_1nf (
    qeydiyyat_id BIGINT NOT NULL,
    dil VARCHAR(50) NOT NULL CHECK (BTRIM(dil) <> ''),
    CONSTRAINT pk_nf1_qeydiyyat_muellim_dil PRIMARY KEY (qeydiyyat_id, dil),
    CONSTRAINT fk_nf1_dil_qeydiyyat FOREIGN KEY (qeydiyyat_id)
        REFERENCES nf1.kurs_qeydiyyat_1nf (qeydiyyat_id)
        ON DELETE CASCADE
);

INSERT INTO nf1.kurs_qeydiyyat_1nf (
    telebe_id, telebe_ad, dogum_tarixi, kurs_kodu, kurs_adi,
    kurs_saati, qiymet, fenn_kodu, fenn_adi, muellim_id,
    muellim_adi, muellim_email, otaq_no, otaq_tutumu,
    filial_kodu, filial_unvani, seher, qeydiyyat_tarixi,
    odenis, imtahan_bali
)
SELECT
    telebe_id, telebe_ad, dogum_tarixi, kurs_kod, kurs_ad,
    kurs_saat, qiymet, fenn_kod, fenn_ad, muellim_id,
    muellim_ad, muellim_email, otaq_no, otaq_tutum,
    filial_kod, filial_unvan, seher, qeyd_tarixi,
    odenis, imtahan_bali
FROM akademiya_raw.kurs_qeydiyyat
ORDER BY telebe_id, kurs_kod;

INSERT INTO nf1.qeydiyyat_telefon_1nf (qeydiyyat_id, telefon)
SELECT DISTINCT q.qeydiyyat_id, BTRIM(t.telefon)
FROM akademiya_raw.kurs_qeydiyyat r
JOIN nf1.kurs_qeydiyyat_1nf q
    ON q.telebe_id = r.telebe_id
   AND q.kurs_kodu = r.kurs_kod
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(r.telefonlar, ',')) AS t (telefon)
WHERE r.telefonlar IS NOT NULL;

INSERT INTO nf1.qeydiyyat_muellim_dil_1nf (qeydiyyat_id, dil)
SELECT DISTINCT q.qeydiyyat_id, BTRIM(d.dil)
FROM akademiya_raw.kurs_qeydiyyat r
JOIN nf1.kurs_qeydiyyat_1nf q
    ON q.telebe_id = r.telebe_id
   AND q.kurs_kodu = r.kurs_kod
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(r.muellim_dilleri, ',')) AS d (dil)
WHERE r.muellim_dilleri IS NOT NULL;

-- ===== Tapşırıq A2 =====
-- Izah (a): 1NF esas cedvelinin tebii namized achari
-- (telebe_id, kurs_kodu)-dur. Biznes qaydasina gore telebe eyni kursa
-- yalniz bir defe yazila biler; sutunlarin hech biri tekbashina setri
-- unikal teyin etmir.
--
-- Izah (b), qismen asililiqlar:
-- telebe_id -> telebe_ad
-- telebe_id -> dogum_tarixi
-- telebe_id -> telefon
-- kurs_kodu -> kurs_adi
-- kurs_kodu -> kurs_saati
-- kurs_kodu -> qiymet
-- kurs_kodu -> fenn_kodu
-- kurs_kodu -> fenn_adi
--
-- Izah (d): parcalanma itkisizdir. telebeler ile qeydiyyatlar telebe_id,
-- kurslar ile qeydiyyatlar kurs_kodu uzre birleshdirilir. Bu sutunlar
-- valideyn cedvellerde PK oldugu ucun JOIN ilkin qeydiyyati artirmadan
-- ve itirmeden geri qurur.

CREATE TABLE nf2.telebeler_2nf (
    telebe_id VARCHAR(10) PRIMARY KEY,
    telebe_adi VARCHAR(100) NOT NULL CHECK (BTRIM(telebe_adi) <> ''),
    dogum_tarixi DATE NOT NULL
);

CREATE TABLE nf2.telebe_telefonlari_2nf (
    telebe_id VARCHAR(10) NOT NULL,
    telefon VARCHAR(20) NOT NULL CHECK (BTRIM(telefon) <> ''),
    CONSTRAINT pk_nf2_telebe_telefon PRIMARY KEY (telebe_id, telefon),
    CONSTRAINT fk_nf2_telefon_telebe FOREIGN KEY (telebe_id)
        REFERENCES nf2.telebeler_2nf (telebe_id)
        ON DELETE CASCADE
);

CREATE TABLE nf2.kurslar_2nf (
    kurs_kodu VARCHAR(10) PRIMARY KEY,
    kurs_adi VARCHAR(100) NOT NULL UNIQUE,
    kurs_saati INTEGER NOT NULL CHECK (kurs_saati > 0),
    qiymet NUMERIC(10, 2) NOT NULL CHECK (qiymet > 0),
    fenn_kodu VARCHAR(10) NOT NULL,
    fenn_adi VARCHAR(100) NOT NULL
);

CREATE TABLE nf2.qeydiyyatlar_2nf (
    telebe_id VARCHAR(10) NOT NULL,
    kurs_kodu VARCHAR(10) NOT NULL,
    muellim_id VARCHAR(10) NOT NULL,
    muellim_adi VARCHAR(100) NOT NULL,
    muellim_email VARCHAR(150) NOT NULL,
    otaq_no VARCHAR(10) NOT NULL,
    otaq_tutumu INTEGER NOT NULL CHECK (otaq_tutumu > 0),
    filial_kodu VARCHAR(10) NOT NULL,
    filial_unvani VARCHAR(200) NOT NULL,
    seher VARCHAR(50) NOT NULL,
    qeydiyyat_tarixi DATE NOT NULL,
    odenis NUMERIC(10, 2) NOT NULL CHECK (odenis >= 0),
    imtahan_bali INTEGER CHECK (imtahan_bali BETWEEN 0 AND 100),
    CONSTRAINT pk_nf2_qeydiyyat PRIMARY KEY (telebe_id, kurs_kodu),
    CONSTRAINT fk_nf2_qeydiyyat_telebe FOREIGN KEY (telebe_id)
        REFERENCES nf2.telebeler_2nf (telebe_id),
    CONSTRAINT fk_nf2_qeydiyyat_kurs FOREIGN KEY (kurs_kodu)
        REFERENCES nf2.kurslar_2nf (kurs_kodu)
);

CREATE TABLE nf2.qeydiyyat_muellim_dilleri_2nf (
    telebe_id VARCHAR(10) NOT NULL,
    kurs_kodu VARCHAR(10) NOT NULL,
    dil VARCHAR(50) NOT NULL CHECK (BTRIM(dil) <> ''),
    CONSTRAINT pk_nf2_qeydiyyat_muellim_dil
        PRIMARY KEY (telebe_id, kurs_kodu, dil),
    CONSTRAINT fk_nf2_dil_qeydiyyat FOREIGN KEY (telebe_id, kurs_kodu)
        REFERENCES nf2.qeydiyyatlar_2nf (telebe_id, kurs_kodu)
        ON DELETE CASCADE
);

INSERT INTO nf2.telebeler_2nf
SELECT DISTINCT telebe_id, telebe_ad, dogum_tarixi
FROM akademiya_raw.kurs_qeydiyyat;

INSERT INTO nf2.telebeler_2nf
VALUES ('T-04', 'Kamran İsmayılov', DATE '2000-07-08');

INSERT INTO nf2.telebe_telefonlari_2nf
SELECT DISTINCT r.telebe_id, BTRIM(t.telefon)
FROM akademiya_raw.kurs_qeydiyyat r
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(r.telefonlar, ',')) AS t (telefon)
WHERE r.telefonlar IS NOT NULL;

INSERT INTO nf2.kurslar_2nf
SELECT DISTINCT kurs_kod, kurs_ad, kurs_saat, qiymet, fenn_kod, fenn_ad
FROM akademiya_raw.kurs_qeydiyyat;

INSERT INTO nf2.kurslar_2nf
VALUES ('PYT-305', 'Django Web', 70, 600, 'F-PYT', 'Proqramlaşdırma');

INSERT INTO nf2.qeydiyyatlar_2nf
SELECT
    telebe_id, kurs_kod, muellim_id, muellim_ad, muellim_email,
    otaq_no, otaq_tutum, filial_kod, filial_unvan, seher,
    qeyd_tarixi, odenis, imtahan_bali
FROM akademiya_raw.kurs_qeydiyyat;

INSERT INTO nf2.qeydiyyat_muellim_dilleri_2nf
SELECT DISTINCT r.telebe_id, r.kurs_kod, BTRIM(d.dil)
FROM akademiya_raw.kurs_qeydiyyat r
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(r.muellim_dilleri, ',')) AS d (dil)
WHERE r.muellim_dilleri IS NOT NULL;

-- ===== Tapşırıq A3 =====
-- Izah (a), tranzitiv asililiqlar:
-- kurs_kodu -> fenn_kodu -> fenn_adi
-- muellim_id -> muellim_adi, muellim_email, fenn_kodu
-- otaq_no -> otaq_tutumu, filial_kodu
-- otaq_no -> filial_kodu -> filial_unvani, seher
--
-- Izah (c): 3NF-den evvel F-01 melumati qeydiyyat setrlerinde 4 defe
-- tekrarlandigi ucun unvan 4 setrde yenilenir. 3NF-den sonra filial
-- melumati bir setrde saxlanilir ve yalniz 1 setr UPDATE olunur.
--
-- Izah (d): 3NF-de her qeyri-trivial X -> A asililiginda X super acar
-- olmalidir, yaxud A namized acarin bir hissesi olan prime atributdur.
-- "Acardan" hissesi 1NF-den sonrakı esas asililigi, "butun acardan"
-- qismen asililigin legvini (2NF), "yalniz acardan" ise tranzitiv
-- asililigin legvini (3NF) ifade edir.

CREATE TABLE akademiya_online.fennler (
    fenn_kodu VARCHAR(10) PRIMARY KEY,
    fenn_adi VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT chk_fenn_kodu CHECK (fenn_kodu LIKE 'F-%')
);

CREATE TABLE akademiya_online.telebeler (
    telebe_id VARCHAR(10) PRIMARY KEY,
    telebe_adi VARCHAR(100) NOT NULL,
    dogum_tarixi DATE NOT NULL,
    CONSTRAINT chk_telebe_id CHECK (telebe_id LIKE 'T-%'),
    CONSTRAINT chk_telebe_adi CHECK (BTRIM(telebe_adi) <> '')
);

CREATE TABLE akademiya_online.filiallar (
    filial_kodu VARCHAR(10) PRIMARY KEY,
    filial_unvani VARCHAR(200) NOT NULL UNIQUE,
    seher VARCHAR(50) NOT NULL,
    CONSTRAINT chk_filial_kodu CHECK (filial_kodu LIKE 'F-%'),
    CONSTRAINT chk_filial_unvani CHECK (BTRIM(filial_unvani) <> ''),
    CONSTRAINT chk_filial_seher CHECK (BTRIM(seher) <> '')
);

CREATE TABLE akademiya_online.qiymet_skalasi (
    herf CHAR(1) PRIMARY KEY,
    minimum_bal INTEGER NOT NULL CHECK (minimum_bal BETWEEN 0 AND 100),
    maksimum_bal INTEGER NOT NULL CHECK (maksimum_bal BETWEEN 0 AND 100),
    CONSTRAINT chk_qiymet_araligi CHECK (minimum_bal <= maksimum_bal),
    CONSTRAINT uq_qiymet_araligi UNIQUE (minimum_bal, maksimum_bal)
);

CREATE TABLE akademiya_online.kurslar (
    kurs_kodu VARCHAR(10) PRIMARY KEY,
    kurs_adi VARCHAR(100) NOT NULL UNIQUE,
    kurs_saati INTEGER NOT NULL CHECK (kurs_saati > 0),
    qiymet NUMERIC(10, 2) NOT NULL CHECK (qiymet > 0),
    fenn_kodu VARCHAR(10) NOT NULL,
    CONSTRAINT fk_kurs_fenn FOREIGN KEY (fenn_kodu)
        REFERENCES akademiya_online.fennler (fenn_kodu)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE akademiya_online.muellimler (
    muellim_id VARCHAR(10) PRIMARY KEY,
    muellim_adi VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    fenn_kodu VARCHAR(10) NOT NULL,
    mentor_id VARCHAR(10),
    CONSTRAINT chk_muellim_id CHECK (muellim_id LIKE 'M-%'),
    CONSTRAINT chk_muellim_email CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_mentor_ozu_deyil CHECK (mentor_id IS NULL OR mentor_id <> muellim_id),
    CONSTRAINT fk_muellim_fenn FOREIGN KEY (fenn_kodu)
        REFERENCES akademiya_online.fennler (fenn_kodu)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_muellim_mentor FOREIGN KEY (mentor_id)
        REFERENCES akademiya_online.muellimler (muellim_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE akademiya_online.telebe_telefonlari (
    telebe_id VARCHAR(10) NOT NULL,
    telefon VARCHAR(20) NOT NULL,
    sira SMALLINT NOT NULL CHECK (sira > 0),
    CONSTRAINT pk_telebe_telefon PRIMARY KEY (telebe_id, telefon),
    CONSTRAINT uq_telefon UNIQUE (telefon),
    CONSTRAINT uq_telebe_telefon_sira UNIQUE (telebe_id, sira),
    CONSTRAINT chk_telefon CHECK (telefon ~ '^[0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}$'),
    CONSTRAINT fk_telefon_telebe FOREIGN KEY (telebe_id)
        REFERENCES akademiya_online.telebeler (telebe_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE akademiya_online.muellim_dilleri (
    muellim_id VARCHAR(10) NOT NULL,
    dil VARCHAR(50) NOT NULL CHECK (BTRIM(dil) <> ''),
    CONSTRAINT pk_muellim_dil PRIMARY KEY (muellim_id, dil),
    CONSTRAINT fk_dil_muellim FOREIGN KEY (muellim_id)
        REFERENCES akademiya_online.muellimler (muellim_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE akademiya_online.otaqlar (
    otaq_no VARCHAR(10) PRIMARY KEY,
    tutum INTEGER NOT NULL CHECK (tutum > 0),
    filial_kodu VARCHAR(10) NOT NULL,
    CONSTRAINT fk_otaq_filial FOREIGN KEY (filial_kodu)
        REFERENCES akademiya_online.filiallar (filial_kodu)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE akademiya_online.qeydiyyatlar (
    telebe_id VARCHAR(10) NOT NULL,
    kurs_kodu VARCHAR(10) NOT NULL,
    muellim_id VARCHAR(10) NOT NULL,
    otaq_no VARCHAR(10) NOT NULL,
    qeydiyyat_tarixi DATE NOT NULL,
    odenis NUMERIC(10, 2) NOT NULL CHECK (odenis >= 0),
    CONSTRAINT pk_qeydiyyat PRIMARY KEY (telebe_id, kurs_kodu),
    CONSTRAINT fk_qeydiyyat_telebe FOREIGN KEY (telebe_id)
        REFERENCES akademiya_online.telebeler (telebe_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_qeydiyyat_kurs FOREIGN KEY (kurs_kodu)
        REFERENCES akademiya_online.kurslar (kurs_kodu)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_qeydiyyat_muellim FOREIGN KEY (muellim_id)
        REFERENCES akademiya_online.muellimler (muellim_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_qeydiyyat_otaq FOREIGN KEY (otaq_no)
        REFERENCES akademiya_online.otaqlar (otaq_no)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE akademiya_online.imtahan_neticeleri (
    telebe_id VARCHAR(10) NOT NULL,
    kurs_kodu VARCHAR(10) NOT NULL,
    imtahan_bali INTEGER NOT NULL CHECK (imtahan_bali BETWEEN 0 AND 100),
    CONSTRAINT pk_imtahan_neticesi PRIMARY KEY (telebe_id, kurs_kodu),
    CONSTRAINT fk_imtahan_qeydiyyat FOREIGN KEY (telebe_id, kurs_kodu)
        REFERENCES akademiya_online.qeydiyyatlar (telebe_id, kurs_kodu)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE INDEX idx_kurs_fenn
    ON akademiya_online.kurslar (fenn_kodu);
CREATE INDEX idx_muellim_fenn
    ON akademiya_online.muellimler (fenn_kodu);
CREATE INDEX idx_otaq_filial
    ON akademiya_online.otaqlar (filial_kodu);
CREATE INDEX idx_qeydiyyat_kurs
    ON akademiya_online.qeydiyyatlar (kurs_kodu);
CREATE INDEX idx_qeydiyyat_otaq
    ON akademiya_online.qeydiyyatlar (otaq_no);
CREATE INDEX idx_muellim_mentor
    ON akademiya_online.muellimler (mentor_id);

CREATE OR REPLACE FUNCTION akademiya_online.fn_qeydiyyat_fenn_yoxla()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    kursun_fenni VARCHAR(10);
    muellimin_fenni VARCHAR(10);
BEGIN
    SELECT fenn_kodu
    INTO kursun_fenni
    FROM akademiya_online.kurslar
    WHERE kurs_kodu = NEW.kurs_kodu;

    SELECT fenn_kodu
    INTO muellimin_fenni
    FROM akademiya_online.muellimler
    WHERE muellim_id = NEW.muellim_id;

    IF kursun_fenni IS DISTINCT FROM muellimin_fenni THEN
        RAISE EXCEPTION
            'Kursun fenni (%) muellimin fenni (%) ile uygun deyil',
            kursun_fenni, muellimin_fenni
            USING ERRCODE = '23514';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM akademiya_online.qeydiyyatlar q
        JOIN akademiya_online.kurslar k
            ON k.kurs_kodu = q.kurs_kodu
        WHERE q.telebe_id = NEW.telebe_id
          AND k.fenn_kodu = kursun_fenni
          AND q.muellim_id <> NEW.muellim_id
          AND (q.telebe_id, q.kurs_kodu)
              IS DISTINCT FROM (NEW.telebe_id, NEW.kurs_kodu)
    ) THEN
        RAISE EXCEPTION
            'Telebenin eyni fenn uzre ferqli muellimi ola bilmez'
            USING ERRCODE = '23505';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_qeydiyyat_fenn_yoxla
BEFORE INSERT OR UPDATE OF kurs_kodu, muellim_id
ON akademiya_online.qeydiyyatlar
FOR EACH ROW
EXECUTE FUNCTION akademiya_online.fn_qeydiyyat_fenn_yoxla();

-- ===== Tapşırıq A4 =====
-- Izah (a): ders(telebe_id, fenn_kodu, muellim_id) ucun
-- (telebe_id, fenn_kodu) -> muellim_id ve muellim_id -> fenn_kodu.
-- Namized acarlar (telebe_id, fenn_kodu) ve
-- (telebe_id, muellim_id)-dir.
--
-- Izah (b): muellim_id -> fenn_kodu asililiginda fenn_kodu prime
-- atributdur, buna gore munasibet 3NF sertini odeyir. Lakin muellim_id
-- super acar deyil, buna gore BCNF pozulur.
--
-- Izah (d): BCNF parcalanmasinda
-- (telebe_id, fenn_kodu) -> muellim_id asililigi ayrica cedvelde
-- birbasha yoxlanilmir. Yekun sxemde trg_qeydiyyat_fenn_yoxla trigger-i
-- kursun fenni ile muellimin fenninin eyni olmasini ve telebenin eyni
-- fenn uzre yalniz bir muelliminin olmasini mecbur edir.

CREATE TABLE norm_demo.muellim_fenn_bcnf (
    muellim_id VARCHAR(10) PRIMARY KEY,
    fenn_kodu VARCHAR(10) NOT NULL,
    CONSTRAINT fk_bcnf_muellim FOREIGN KEY (muellim_id)
        REFERENCES akademiya_online.muellimler (muellim_id),
    CONSTRAINT fk_bcnf_fenn FOREIGN KEY (fenn_kodu)
        REFERENCES akademiya_online.fennler (fenn_kodu)
);

CREATE TABLE norm_demo.telebe_muellim_bcnf (
    telebe_id VARCHAR(10) NOT NULL,
    muellim_id VARCHAR(10) NOT NULL,
    CONSTRAINT pk_bcnf_telebe_muellim PRIMARY KEY (telebe_id, muellim_id),
    CONSTRAINT fk_bcnf_telebe FOREIGN KEY (telebe_id)
        REFERENCES akademiya_online.telebeler (telebe_id),
    CONSTRAINT fk_bcnf_telebe_muellim FOREIGN KEY (muellim_id)
        REFERENCES norm_demo.muellim_fenn_bcnf (muellim_id)
);

-- ===== Tapşırıq A5 =====
-- Izah (a): 2 fenn x 3 dil = 6 setir:
-- (M-05,F-SQL,Azərbaycan), (M-05,F-SQL,İngilis),
-- (M-05,F-SQL,Rus), (M-05,F-PYT,Azərbaycan),
-- (M-05,F-PYT,İngilis), (M-05,F-PYT,Rus).
-- Izah (b): muellim_id ->> tedris_fenn ve muellim_id ->> bildiyi_dil.
-- Izah (c): iki musteqil coxdeyerli fakt Dekart hasili yaradir.
-- Alman dili elave olunanda 2, yeni fenn elave olunanda 3 setir lazimdir.
-- Izah (d): parcalanmadan evvel 6, sonra 2 + 3 = 5 setir saxlanilir.

CREATE TABLE norm_demo.muellim_bacariq_4nf_pozuntu (
    muellim_id VARCHAR(10) NOT NULL,
    tedris_fenn VARCHAR(10) NOT NULL,
    bildiyi_dil VARCHAR(50) NOT NULL,
    CONSTRAINT pk_4nf_pozuntu PRIMARY KEY (muellim_id, tedris_fenn, bildiyi_dil),
    CONSTRAINT fk_4nf_pozuntu_muellim FOREIGN KEY (muellim_id)
        REFERENCES akademiya_online.muellimler (muellim_id),
    CONSTRAINT fk_4nf_pozuntu_fenn FOREIGN KEY (tedris_fenn)
        REFERENCES akademiya_online.fennler (fenn_kodu)
);

CREATE TABLE norm_demo.muellim_tedris_fenn_4nf (
    muellim_id VARCHAR(10) NOT NULL,
    fenn_kodu VARCHAR(10) NOT NULL,
    CONSTRAINT pk_4nf_muellim_fenn PRIMARY KEY (muellim_id, fenn_kodu),
    CONSTRAINT fk_4nf_muellim FOREIGN KEY (muellim_id)
        REFERENCES akademiya_online.muellimler (muellim_id),
    CONSTRAINT fk_4nf_fenn FOREIGN KEY (fenn_kodu)
        REFERENCES akademiya_online.fennler (fenn_kodu)
);

CREATE TABLE norm_demo.muellim_bildiyi_dil_4nf (
    muellim_id VARCHAR(10) NOT NULL,
    dil VARCHAR(50) NOT NULL CHECK (BTRIM(dil) <> ''),
    CONSTRAINT pk_4nf_muellim_dil PRIMARY KEY (muellim_id, dil),
    CONSTRAINT fk_4nf_dil_muellim FOREIGN KEY (muellim_id)
        REFERENCES akademiya_online.muellimler (muellim_id)
);

-- A5 melumatlari yekun cedveller doldurulduqdan sonra elave olunur.

-- ===== Tapşırıq A6 =====
-- Izah (a): tedris_plani cedvelinde hec bir tek atribut digerlerini
-- funksional teyin etmir ve musteqil coxqiymetli fakt yoxdur. Buna gore
-- munasibet 4NF-dedir, amma uclu join asililigi sebebinden 5NF deyil.

CREATE TABLE norm_demo.tedris_plani_4nf (
    muellim_id VARCHAR(10) NOT NULL,
    kurs_kodu VARCHAR(10) NOT NULL,
    filial_kodu VARCHAR(10) NOT NULL,
    CONSTRAINT pk_tedris_plani_4nf
        PRIMARY KEY (muellim_id, kurs_kodu, filial_kodu),
    CONSTRAINT fk_tedris_plani_muellim FOREIGN KEY (muellim_id)
        REFERENCES akademiya_online.muellimler (muellim_id),
    CONSTRAINT fk_tedris_plani_kurs FOREIGN KEY (kurs_kodu)
        REFERENCES akademiya_online.kurslar (kurs_kodu),
    CONSTRAINT fk_tedris_plani_filial FOREIGN KEY (filial_kodu)
        REFERENCES akademiya_online.filiallar (filial_kodu)
);

CREATE TABLE akademiya_online.muellim_kurs (
    muellim_id VARCHAR(10) NOT NULL,
    kurs_kodu VARCHAR(10) NOT NULL,
    CONSTRAINT pk_muellim_kurs PRIMARY KEY (muellim_id, kurs_kodu),
    CONSTRAINT fk_muellim_kurs_muellim FOREIGN KEY (muellim_id)
        REFERENCES akademiya_online.muellimler (muellim_id),
    CONSTRAINT fk_muellim_kurs_kurs FOREIGN KEY (kurs_kodu)
        REFERENCES akademiya_online.kurslar (kurs_kodu)
);

CREATE TABLE akademiya_online.kurs_filial (
    kurs_kodu VARCHAR(10) NOT NULL,
    filial_kodu VARCHAR(10) NOT NULL,
    CONSTRAINT pk_kurs_filial PRIMARY KEY (kurs_kodu, filial_kodu),
    CONSTRAINT fk_kurs_filial_kurs FOREIGN KEY (kurs_kodu)
        REFERENCES akademiya_online.kurslar (kurs_kodu),
    CONSTRAINT fk_kurs_filial_filial FOREIGN KEY (filial_kodu)
        REFERENCES akademiya_online.filiallar (filial_kodu)
);

CREATE TABLE akademiya_online.muellim_filial (
    muellim_id VARCHAR(10) NOT NULL,
    filial_kodu VARCHAR(10) NOT NULL,
    CONSTRAINT pk_muellim_filial PRIMARY KEY (muellim_id, filial_kodu),
    CONSTRAINT fk_muellim_filial_muellim FOREIGN KEY (muellim_id)
        REFERENCES akademiya_online.muellimler (muellim_id),
    CONSTRAINT fk_muellim_filial_filial FOREIGN KEY (filial_kodu)
        REFERENCES akademiya_online.filiallar (filial_kodu)
);

CREATE INDEX idx_muellim_kurs_kurs
    ON akademiya_online.muellim_kurs (kurs_kodu);
CREATE INDEX idx_kurs_filial_filial
    ON akademiya_online.kurs_filial (filial_kodu);
CREATE INDEX idx_muellim_filial_filial
    ON akademiya_online.muellim_filial (filial_kodu);

-- Yekun sxemin test melumatlari.
INSERT INTO akademiya_online.fennler (fenn_kodu, fenn_adi)
VALUES
    ('F-SQL', 'Verilənlər Bazaları'),
    ('F-PYT', 'Proqramlaşdırma'),
    ('F-DSC', 'Data Science'),
    ('F-DIZ', 'Dizayn');

INSERT INTO akademiya_online.telebeler (telebe_id, telebe_adi, dogum_tarixi)
VALUES
    ('T-01', 'Aysel Məmmədova', DATE '2001-04-12'),
    ('T-02', 'Elvin Hüseynov', DATE '1999-11-03'),
    ('T-03', 'Nigar Səfərova', DATE '2003-02-20'),
    ('T-04', 'Kamran İsmayılov', DATE '2000-07-08'),
    ('T-05', 'Leyla Orucova', DATE '2002-09-30');

INSERT INTO akademiya_online.filiallar (filial_kodu, filial_unvani, seher)
VALUES
    ('F-01', 'Bakı, Nizami küç. 12', 'Bakı'),
    ('F-02', 'Gəncə, Atatürk pr. 5', 'Gəncə'),
    ('F-03', 'Sumqayıt, Sülh küç. 3', 'Sumqayıt');

INSERT INTO akademiya_online.qiymet_skalasi (herf, minimum_bal, maksimum_bal)
VALUES
    ('A', 90, 100),
    ('B', 80, 89),
    ('C', 70, 79),
    ('D', 60, 69),
    ('F', 0, 59);

INSERT INTO akademiya_online.kurslar (
    kurs_kodu, kurs_adi, kurs_saati, qiymet, fenn_kodu
)
VALUES
    ('SQL-101', 'SQL Əsasları', 40, 350, 'F-SQL'),
    ('PYT-201', 'Python Başlanğıc', 60, 500, 'F-PYT'),
    ('DSC-301', 'Data Science', 80, 700, 'F-DSC'),
    ('SQL-202', 'Ətraflı SQL', 50, 450, 'F-SQL'),
    ('PYT-305', 'Django Web', 70, 600, 'F-PYT');

INSERT INTO akademiya_online.muellimler (
    muellim_id, muellim_adi, email, fenn_kodu, mentor_id
)
VALUES
    ('M-05', 'Rəşad Quliyev', 'reshad@akademiya.az', 'F-SQL', NULL),
    ('M-13', 'Samir Nəbiyev', 'samir@akademiya.az', 'F-PYT', NULL),
    ('M-07', 'Nigar Əliyeva', 'nigar@akademiya.az', 'F-PYT', 'M-05'),
    ('M-09', 'Tural Abbasov', 'tural@akademiya.az', 'F-DSC', 'M-05'),
    ('M-11', 'Aygün Vəliyeva', 'aygun@akademiya.az', 'F-SQL', 'M-07');

INSERT INTO akademiya_online.telebe_telefonlari (telebe_id, telefon, sira)
VALUES
    ('T-01', '055-111-22-33', 1),
    ('T-01', '070-111-22-33', 2),
    ('T-02', '051-777-88-99', 1),
    ('T-03', '070-222-33-44', 1),
    ('T-03', '055-222-33-44', 2);

INSERT INTO akademiya_online.muellim_dilleri (muellim_id, dil)
VALUES
    ('M-05', 'Azərbaycan'),
    ('M-05', 'İngilis'),
    ('M-05', 'Rus'),
    ('M-07', 'Azərbaycan'),
    ('M-07', 'İngilis'),
    ('M-09', 'Azərbaycan'),
    ('M-11', 'Azərbaycan'),
    ('M-11', 'Rus');

INSERT INTO akademiya_online.otaqlar (otaq_no, tutum, filial_kodu)
VALUES
    ('A-201', 25, 'F-01'),
    ('A-305', 30, 'F-01'),
    ('B-305', 22, 'F-02'),
    ('B-410', 18, 'F-02');

INSERT INTO akademiya_online.qeydiyyatlar (
    telebe_id, kurs_kodu, muellim_id, otaq_no,
    qeydiyyat_tarixi, odenis
)
VALUES
    ('T-01', 'SQL-101', 'M-05', 'A-201', DATE '2025-02-10', 350),
    ('T-01', 'PYT-201', 'M-07', 'A-305', DATE '2025-02-12', 500),
    ('T-02', 'SQL-101', 'M-05', 'A-201', DATE '2025-02-15', 350),
    ('T-03', 'DSC-301', 'M-09', 'B-410', DATE '2025-03-01', 700),
    ('T-05', 'SQL-101', 'M-05', 'A-201', DATE '2025-02-18', 350),
    ('T-02', 'PYT-201', 'M-07', 'B-305', DATE '2025-03-05', 500),
    ('T-03', 'SQL-202', 'M-11', 'B-305', DATE '2025-03-10', 450);

INSERT INTO akademiya_online.imtahan_neticeleri (
    telebe_id, kurs_kodu, imtahan_bali
)
VALUES
    ('T-01', 'SQL-101', 92),
    ('T-01', 'PYT-201', 78),
    ('T-02', 'SQL-101', 65),
    ('T-03', 'DSC-301', 88),
    ('T-02', 'PYT-201', 54),
    ('T-03', 'SQL-202', 71);

INSERT INTO norm_demo.muellim_fenn_bcnf (muellim_id, fenn_kodu)
SELECT muellim_id, fenn_kodu
FROM akademiya_online.muellimler;

INSERT INTO norm_demo.telebe_muellim_bcnf (telebe_id, muellim_id)
SELECT DISTINCT telebe_id, muellim_id
FROM akademiya_online.qeydiyyatlar;

INSERT INTO norm_demo.muellim_bacariq_4nf_pozuntu
VALUES
    ('M-05', 'F-SQL', 'Azərbaycan'),
    ('M-05', 'F-SQL', 'İngilis'),
    ('M-05', 'F-SQL', 'Rus'),
    ('M-05', 'F-PYT', 'Azərbaycan'),
    ('M-05', 'F-PYT', 'İngilis'),
    ('M-05', 'F-PYT', 'Rus');

INSERT INTO norm_demo.muellim_tedris_fenn_4nf
VALUES
    ('M-05', 'F-SQL'),
    ('M-05', 'F-PYT');

INSERT INTO norm_demo.muellim_bildiyi_dil_4nf
VALUES
    ('M-05', 'Azərbaycan'),
    ('M-05', 'İngilis'),
    ('M-05', 'Rus');

INSERT INTO norm_demo.tedris_plani_4nf
VALUES
    ('M-05', 'SQL-101', 'F-01'),
    ('M-05', 'SQL-202', 'F-01'),
    ('M-11', 'SQL-101', 'F-01'),
    ('M-05', 'SQL-101', 'F-02');

INSERT INTO akademiya_online.muellim_kurs
VALUES
    ('M-05', 'SQL-101'),
    ('M-05', 'SQL-202'),
    ('M-11', 'SQL-101');

INSERT INTO akademiya_online.kurs_filial
VALUES
    ('SQL-101', 'F-01'),
    ('SQL-202', 'F-01'),
    ('SQL-101', 'F-02');

INSERT INTO akademiya_online.muellim_filial
VALUES
    ('M-05', 'F-01'),
    ('M-11', 'F-01'),
    ('M-05', 'F-02');

-- A6 (b): uclu cedvelin binar proyeksiyalarinin mezmunu.
SELECT * FROM akademiya_online.muellim_kurs ORDER BY muellim_id, kurs_kodu;
SELECT * FROM akademiya_online.kurs_filial ORDER BY kurs_kodu, filial_kodu;
SELECT * FROM akademiya_online.muellim_filial ORDER BY muellim_id, filial_kodu;

-- A6 (c): her uc proyeksiya geri birlesende ilkin 4 setir alinir.
SELECT muellim_id, kurs_kodu, filial_kodu
FROM akademiya_online.muellim_kurs
JOIN akademiya_online.kurs_filial USING (kurs_kodu)
JOIN akademiya_online.muellim_filial USING (muellim_id, filial_kodu)
ORDER BY muellim_id, kurs_kodu, filial_kodu;

WITH yeniden_qurulan AS (
    SELECT muellim_id, kurs_kodu, filial_kodu
    FROM akademiya_online.muellim_kurs
    JOIN akademiya_online.kurs_filial USING (kurs_kodu)
    JOIN akademiya_online.muellim_filial USING (muellim_id, filial_kodu)
)
SELECT
    NOT EXISTS (
        SELECT * FROM norm_demo.tedris_plani_4nf
        EXCEPT
        SELECT * FROM yeniden_qurulan
    )
    AND NOT EXISTS (
        SELECT * FROM yeniden_qurulan
        EXCEPT
        SELECT * FROM norm_demo.tedris_plani_4nf
    ) AS ilkin_cedvelle_eynidir;

-- A6 (d): yalniz iki proyeksiya M-11, SQL-101, F-02 saxta setrini
-- yaradir. Bu setir M-11-in F-02-de ishlemediyi halda orada SQL-101
-- tedris etdiyini sehv iddia edir; buna gore uclu join asililigi lazimdir.
SELECT muellim_id, kurs_kodu, filial_kodu
FROM akademiya_online.muellim_kurs
JOIN akademiya_online.kurs_filial USING (kurs_kodu)
ORDER BY muellim_id, kurs_kodu, filial_kodu;

-- ===== Tapşırıq A7 =====
-- Izah (a): A3-A6 bloklarinda yekun sxem asili olmayan cedvellerden
-- bashlayaraq quruldu; asili cedveller sonra yaradildi. Butun PK, FK,
-- UNIQUE, CHECK ve NOT NULL qaydalari DDL daxilinde verildi. Mentorluq
-- muellimler.mentor_id self-reference FOREIGN KEY-i ile qorunur.
--
-- Izah (b), ER kardinalliqlari:
-- fennler 1:N kurslar; fennler 1:N muellimler;
-- telebeler 1:N telebe_telefonlari;
-- telebeler M:N kurslar (qeydiyyatlar vasitesile);
-- muellimler 1:N muellim_dilleri;
-- filiallar 1:N otaqlar; otaqlar 1:N qeydiyyatlar;
-- qeydiyyatlar 1:0..1 imtahan_neticeleri;
-- muellimler 1:N muellimler (mentor self-reference);
-- muellimler, kurslar ve filiallar uclu elaqesi 5NF proyeksiyalari ile.
-- Tam ER diaqrami README.md faylinda verilib.
--
-- Izah (c): normallasdirma olculmush JOIN xerci oxu performansini real
-- olaraq pislestirdikde ziyanli ola biler; denormalizasiya yalniz olcu
-- ve profil neticesinde, butovluk sinxron saxlanila bildikde esaslidir.

-- ================================================================
-- HISSE B - JOIN NOVLERI
-- ================================================================

-- ===== Tapşırıq B1 =====
-- Izah: neticede 7 qeydiyyata uygun 7 setir var. T-04-un
-- qeydiyyatlar cedvelinde setri olmadigi ucun INNER JOIN onu qaytarmir.
SELECT
    t.telebe_adi,
    k.kurs_adi,
    f.fenn_adi,
    q.odenis
FROM akademiya_online.qeydiyyatlar q
JOIN akademiya_online.telebeler t
    ON t.telebe_id = q.telebe_id
JOIN akademiya_online.kurslar k
    ON k.kurs_kodu = q.kurs_kodu
JOIN akademiya_online.fennler f
    ON f.fenn_kodu = k.fenn_kodu
ORDER BY t.telebe_adi, k.kurs_adi;

-- ===== Tapşırıq B2 =====
-- B2 (a): telefonu olmayan T-04 ve T-05 de neticede qalir.
SELECT
    t.telebe_id,
    t.telebe_adi,
    COALESCE(tt.telefon, 'Nömrə yoxdur') AS telefon
FROM akademiya_online.telebeler t
LEFT JOIN akademiya_online.telebe_telefonlari tt
    ON tt.telebe_id = t.telebe_id
ORDER BY t.telebe_id, tt.telefon;

-- B2 (b): imtahan neticesi olmayan qeydiyyat metnle gosterilir.
SELECT
    q.telebe_id,
    q.kurs_kodu,
    COALESCE(i.imtahan_bali::TEXT, 'İmtahan verilməyib') AS imtahan_neticesi
FROM akademiya_online.qeydiyyatlar q
LEFT JOIN akademiya_online.imtahan_neticeleri i
    ON i.telebe_id = q.telebe_id
   AND i.kurs_kodu = q.kurs_kodu
ORDER BY q.telebe_id, q.kurs_kodu;

-- B2 (c), sehv variant: WHERE sag cedvelde NULL olan setirleri silir.
-- T-04 ve T-05 neticeden itdiyi ucun LEFT JOIN faktiki INNER JOIN kimi
-- davranir.
SELECT
    t.telebe_id,
    t.telebe_adi,
    tt.telefon
FROM akademiya_online.telebeler t
LEFT JOIN akademiya_online.telebe_telefonlari tt
    ON tt.telebe_id = t.telebe_id
WHERE tt.telefon LIKE '055%'
ORDER BY t.telebe_id;

-- B2 (c), duzgun variant: filtr ON daxilindedir. Butun telebeler qalir,
-- 055 ile bashlayan nomresi olmayanlarin sag hissesi NULL olur.
SELECT
    t.telebe_id,
    t.telebe_adi,
    tt.telefon
FROM akademiya_online.telebeler t
LEFT JOIN akademiya_online.telebe_telefonlari tt
    ON tt.telebe_id = t.telebe_id
   AND tt.telefon LIKE '055%'
ORDER BY t.telebe_id;

-- ===== Tapşırıq B3 =====
-- RIGHT JOIN varianti. PYT-305 ucun telebe_sayi 0 qayidir.
SELECT
    k.kurs_kodu,
    k.kurs_adi,
    COUNT(q.telebe_id) AS telebe_sayi
FROM akademiya_online.qeydiyyatlar q
RIGHT JOIN akademiya_online.kurslar k
    ON k.kurs_kodu = q.kurs_kodu
GROUP BY k.kurs_kodu, k.kurs_adi
ORDER BY k.kurs_kodu;

-- Eyni neticenin LEFT JOIN varianti.
SELECT
    k.kurs_kodu,
    k.kurs_adi,
    COUNT(q.telebe_id) AS telebe_sayi
FROM akademiya_online.kurslar k
LEFT JOIN akademiya_online.qeydiyyatlar q
    ON q.kurs_kodu = k.kurs_kodu
GROUP BY k.kurs_kodu, k.kurs_adi
ORDER BY k.kurs_kodu;

-- Izah: LEFT JOIN-da qorunacaq esas cedvel sorğunun solunda oxunur ve
-- mentiqi istiqamet daha aydin gorunur. RIGHT JOIN eyni neticeni verse
-- de oxunush istiqametini tersine cevirdiyi ucun praktikada daha azdir.

-- ===== Tapşırıq B4 =====
-- B4 (a): FK sebebinden fennsiz kurs ola bilmez, amma F-DIZ-in kursu
-- olmadigi ucun hemin setir "Kursu olmayan fənn" kimi gorsenir.
SELECT
    f.fenn_kodu,
    f.fenn_adi,
    k.kurs_kodu,
    k.kurs_adi,
    CASE
        WHEN f.fenn_kodu IS NULL THEN 'Fənni olmayan kurs'
        WHEN k.kurs_kodu IS NULL THEN 'Kursu olmayan fənn'
        ELSE 'Uyğun'
    END AS veziyyet
FROM akademiya_online.fennler f
FULL OUTER JOIN akademiya_online.kurslar k
    ON k.fenn_kodu = f.fenn_kodu
ORDER BY f.fenn_kodu NULLS LAST, k.kurs_kodu NULLS LAST;

-- B4 (b): yalniz uygun gelmeyen setirler.
SELECT
    f.fenn_kodu,
    f.fenn_adi,
    k.kurs_kodu,
    k.kurs_adi
FROM akademiya_online.fennler f
FULL OUTER JOIN akademiya_online.kurslar k
    ON k.fenn_kodu = f.fenn_kodu
WHERE f.fenn_kodu IS NULL
   OR k.kurs_kodu IS NULL
ORDER BY f.fenn_kodu NULLS LAST, k.kurs_kodu NULLS LAST;

-- B4 (c): M-13 sol terefde tek qalan muellim kimi gorsenir.
-- Sag terefde tek qalan qeydiyyat yoxdur, cunki FOREIGN KEY movcud
-- olmayan muellim_id ile qeydiyyat yazmaga icaze vermir.
SELECT
    m.muellim_id,
    m.muellim_adi,
    q.telebe_id,
    q.kurs_kodu
FROM akademiya_online.muellimler m
FULL OUTER JOIN akademiya_online.qeydiyyatlar q
    ON q.muellim_id = m.muellim_id
ORDER BY m.muellim_id NULLS LAST, q.telebe_id NULLS LAST, q.kurs_kodu;

-- B4 (d): FULL OUTER JOIN neticesi LEFT JOIN UNION RIGHT JOIN ile.
SELECT
    m.muellim_id,
    m.muellim_adi,
    q.telebe_id,
    q.kurs_kodu
FROM akademiya_online.muellimler m
LEFT JOIN akademiya_online.qeydiyyatlar q
    ON q.muellim_id = m.muellim_id
UNION
SELECT
    m.muellim_id,
    m.muellim_adi,
    q.telebe_id,
    q.kurs_kodu
FROM akademiya_online.muellimler m
RIGHT JOIN akademiya_online.qeydiyyatlar q
    ON q.muellim_id = m.muellim_id
ORDER BY muellim_id NULLS LAST, telebe_id NULLS LAST, kurs_kodu;

-- Izah: UNION uygun gelen eyni setirleri bir defe saxlayir. UNION ALL
-- istifade edilse, her match hem LEFT, hem RIGHT hisseden geldiyi ucun
-- iki defe qayidardi.

-- ===== Tapşırıq B5 =====
-- B5 (a): 3 filial x 5 qiymet herfi = 15 setir.
SELECT
    f.filial_kodu,
    f.seher,
    qs.herf
FROM akademiya_online.filiallar f
CROSS JOIN akademiya_online.qiymet_skalasi qs
ORDER BY f.filial_kodu, qs.minimum_bal DESC;

SELECT COUNT(*) AS dekart_setir_sayi
FROM akademiya_online.filiallar
CROSS JOIN akademiya_online.qiymet_skalasi;

-- B5 (b): fenn x qiymet matrisi. Neticesi olmayan xanalar da 0-dir.
SELECT
    f.fenn_kodu,
    f.fenn_adi,
    qs.herf,
    COUNT(i.telebe_id) AS netice_sayi
FROM akademiya_online.fennler f
CROSS JOIN akademiya_online.qiymet_skalasi qs
LEFT JOIN akademiya_online.kurslar k
    ON k.fenn_kodu = f.fenn_kodu
LEFT JOIN akademiya_online.imtahan_neticeleri i
    ON i.kurs_kodu = k.kurs_kodu
   AND i.imtahan_bali BETWEEN qs.minimum_bal AND qs.maksimum_bal
GROUP BY f.fenn_kodu, f.fenn_adi, qs.herf, qs.minimum_bal
ORDER BY f.fenn_kodu, qs.minimum_bal DESC;

-- B5 (c): tesadufi Dekart partlayishinin esas sebebi elaqeli cedveller
-- arasinda JOIN sertinin unudulmasi ve her setrin her setrle birleshmesidir.

-- ===== Tapşırıq B6 =====
-- B6 (a): muellim ve mentoru eyni cedvelin iki rolu kimi oxunur.
SELECT
    m.muellim_adi,
    COALESCE(mentor.muellim_adi, 'Mentoru yoxdur') AS mentor_adi
FROM akademiya_online.muellimler m
LEFT JOIN akademiya_online.muellimler mentor
    ON mentor.muellim_id = m.mentor_id
ORDER BY m.muellim_id;

-- B6 (b): mentoru ile eyni fenni tedris eden muellimler.
SELECT
    m.muellim_adi,
    mentor.muellim_adi AS mentor_adi,
    f.fenn_adi
FROM akademiya_online.muellimler m
JOIN akademiya_online.muellimler mentor
    ON mentor.muellim_id = m.mentor_id
   AND mentor.fenn_kodu = m.fenn_kodu
JOIN akademiya_online.fennler f
    ON f.fenn_kodu = m.fenn_kodu
ORDER BY m.muellim_id;

-- B6 (c): < serti (A,B) ile (B,A)-dan yalniz birini saxlayir.
SELECT
    q1.kurs_kodu,
    t1.telebe_adi AS birinci_telebe,
    t2.telebe_adi AS ikinci_telebe
FROM akademiya_online.qeydiyyatlar q1
JOIN akademiya_online.qeydiyyatlar q2
    ON q2.kurs_kodu = q1.kurs_kodu
   AND q1.telebe_id < q2.telebe_id
JOIN akademiya_online.telebeler t1
    ON t1.telebe_id = q1.telebe_id
JOIN akademiya_online.telebeler t2
    ON t2.telebe_id = q2.telebe_id
ORDER BY q1.kurs_kodu, q1.telebe_id, q2.telebe_id;

-- B6 (d): alias mecburidir, cunki eyni cedvelin sutunlarinin hansi
-- rola - muellime, mentora ve ya mentorun mentoruna aid oldugu yalniz
-- alias ile ferqlendirilir.
SELECT
    m.muellim_adi,
    COALESCE(mentor.muellim_adi, 'Mentoru yoxdur') AS mentor_adi,
    COALESCE(mentorun_mentoru.muellim_adi, 'Mentorun mentoru yoxdur')
        AS mentorun_mentoru
FROM akademiya_online.muellimler m
LEFT JOIN akademiya_online.muellimler mentor
    ON mentor.muellim_id = m.mentor_id
LEFT JOIN akademiya_online.muellimler mentorun_mentoru
    ON mentorun_mentoru.muellim_id = mentor.mentor_id
ORDER BY m.muellim_id;

-- ===== Tapşırıq B7 =====
-- B7 (a): NATURAL JOIN her iki cedvelde eyni adli yegane sutun olan
-- filial_kodu uzre avtomatik birleshir.
SELECT *
FROM akademiya_online.otaqlar
NATURAL JOIN akademiya_online.filiallar
ORDER BY otaq_no;

-- B7 (b): USING birleshme sutununu SELECT * neticesinde bir defe verir.
SELECT *
FROM akademiya_online.otaqlar
JOIN akademiya_online.filiallar USING (filial_kodu)
ORDER BY otaq_no;

-- B7 (c): ON variantinda SELECT * her iki cedvelin filial_kodu
-- sutununu ayrica qaytarir.
SELECT *
FROM akademiya_online.otaqlar o
JOIN akademiya_online.filiallar f
    ON f.filial_kodu = o.filial_kodu
ORDER BY o.otaq_no;

-- B7 (d): iki created_at sutununa qesden ferqli deyer verilir.
ALTER TABLE akademiya_online.otaqlar
    ADD COLUMN created_at TIMESTAMP NOT NULL
        DEFAULT TIMESTAMP '2025-01-01 00:00:00';

ALTER TABLE akademiya_online.filiallar
    ADD COLUMN created_at TIMESTAMP NOT NULL
        DEFAULT TIMESTAMP '2025-01-02 00:00:00';

-- Indi NATURAL JOIN hem filial_kodu, hem created_at uzre birleshir.
-- created_at deyerleri ferqli oldugu ucun netice 0 setirdir.
SELECT *
FROM akademiya_online.otaqlar
NATURAL JOIN akademiya_online.filiallar;

-- Izah: sxeme eyni adli yeni sutun elave edilmesi NATURAL JOIN
-- mentiqini sessizce deyishir. Buna gore istehsal kodunda birleshme
-- sutunlari ON ve ya USING ile achiq yazilmalidir.
ALTER TABLE akademiya_online.otaqlar DROP COLUMN created_at;
ALTER TABLE akademiya_online.filiallar DROP COLUMN created_at;

-- ===== Tapşırıq B8 =====
-- B8 (a): tam INNER JOIN zenciri yalniz imtahan neticesi olan 6
-- qeydiyyati qaytarir.
SELECT
    t.telebe_adi,
    k.kurs_adi,
    f.fenn_adi,
    m.muellim_adi,
    o.otaq_no,
    o.tutum AS otaq_tutumu,
    fl.filial_unvani,
    fl.seher,
    q.odenis,
    i.imtahan_bali
FROM akademiya_online.qeydiyyatlar q
JOIN akademiya_online.telebeler t
    ON t.telebe_id = q.telebe_id
JOIN akademiya_online.kurslar k
    ON k.kurs_kodu = q.kurs_kodu
JOIN akademiya_online.fennler f
    ON f.fenn_kodu = k.fenn_kodu
JOIN akademiya_online.muellimler m
    ON m.muellim_id = q.muellim_id
JOIN akademiya_online.otaqlar o
    ON o.otaq_no = q.otaq_no
JOIN akademiya_online.filiallar fl
    ON fl.filial_kodu = o.filial_kodu
JOIN akademiya_online.imtahan_neticeleri i
    ON i.telebe_id = q.telebe_id
   AND i.kurs_kodu = q.kurs_kodu
ORDER BY t.telebe_id, k.kurs_kodu;

-- B8 (b): yalniz imtahan_neticeleri bendindeki INNER JOIN LEFT JOIN
-- ile evez olundu. Buna gore T-05 NULL imtahan_bali ile neticede qalir.
SELECT
    t.telebe_adi,
    k.kurs_adi,
    f.fenn_adi,
    m.muellim_adi,
    o.otaq_no,
    o.tutum AS otaq_tutumu,
    fl.filial_unvani,
    fl.seher,
    q.odenis,
    i.imtahan_bali
FROM akademiya_online.qeydiyyatlar q
JOIN akademiya_online.telebeler t
    ON t.telebe_id = q.telebe_id
JOIN akademiya_online.kurslar k
    ON k.kurs_kodu = q.kurs_kodu
JOIN akademiya_online.fennler f
    ON f.fenn_kodu = k.fenn_kodu
JOIN akademiya_online.muellimler m
    ON m.muellim_id = q.muellim_id
JOIN akademiya_online.otaqlar o
    ON o.otaq_no = q.otaq_no
JOIN akademiya_online.filiallar fl
    ON fl.filial_kodu = o.filial_kodu
LEFT JOIN akademiya_online.imtahan_neticeleri i
    ON i.telebe_id = q.telebe_id
   AND i.kurs_kodu = q.kurs_kodu
ORDER BY t.telebe_id, k.kurs_kodu;

-- B8 (c), qesden sehv zencir: imtahan neticesi LEFT JOIN edildikden
-- sonra qiymet_skalasi INNER JOIN olunur. NULL bal hech bir araliga
-- uygun gelmediyi ucun T-05 yeniden neticeden itir.
SELECT
    t.telebe_adi,
    k.kurs_adi,
    i.imtahan_bali,
    qs.herf
FROM akademiya_online.qeydiyyatlar q
JOIN akademiya_online.telebeler t
    ON t.telebe_id = q.telebe_id
JOIN akademiya_online.kurslar k
    ON k.kurs_kodu = q.kurs_kodu
LEFT JOIN akademiya_online.imtahan_neticeleri i
    ON i.telebe_id = q.telebe_id
   AND i.kurs_kodu = q.kurs_kodu
JOIN akademiya_online.qiymet_skalasi qs
    ON i.imtahan_bali BETWEEN qs.minimum_bal AND qs.maksimum_bal
ORDER BY t.telebe_id, k.kurs_kodu;

-- ===== Tapşırıq B9 =====
-- B9 (a): beraberlik deyil, bal araligi ile non-equi JOIN.
SELECT
    t.telebe_adi,
    i.kurs_kodu,
    i.imtahan_bali,
    qs.herf
FROM akademiya_online.imtahan_neticeleri i
JOIN akademiya_online.telebeler t
    ON t.telebe_id = i.telebe_id
JOIN akademiya_online.qiymet_skalasi qs
    ON i.imtahan_bali BETWEEN qs.minimum_bal AND qs.maksimum_bal
ORDER BY i.imtahan_bali DESC, t.telebe_id;

-- B9 (b): butun herfler qalir; istifade olunmayan herf ucun say ve
-- orta bal 0 qaytarilir.
SELECT
    qs.herf,
    COUNT(i.telebe_id) AS netice_sayi,
    COALESCE(ROUND(AVG(i.imtahan_bali), 2), 0) AS orta_bal
FROM akademiya_online.qiymet_skalasi qs
LEFT JOIN akademiya_online.imtahan_neticeleri i
    ON i.imtahan_bali BETWEEN qs.minimum_bal AND qs.maksimum_bal
GROUP BY qs.herf, qs.minimum_bal
ORDER BY qs.minimum_bal DESC;

-- B9 (c): her netice ozunden daha yuksek neticelerle birleshir.
SELECT
    t.telebe_adi,
    i1.kurs_kodu,
    i1.imtahan_bali,
    COUNT(i2.telebe_id) AS daha_yuksek_netice_sayi
FROM akademiya_online.imtahan_neticeleri i1
JOIN akademiya_online.telebeler t
    ON t.telebe_id = i1.telebe_id
LEFT JOIN akademiya_online.imtahan_neticeleri i2
    ON i2.imtahan_bali > i1.imtahan_bali
GROUP BY t.telebe_adi, i1.telebe_id, i1.kurs_kodu, i1.imtahan_bali
ORDER BY i1.imtahan_bali DESC, i1.telebe_id;

-- ===== Tapşırıq B10 =====
-- B10 (a): LEFT anti join.
SELECT
    t.telebe_id,
    t.telebe_adi
FROM akademiya_online.telebeler t
LEFT JOIN akademiya_online.qeydiyyatlar q
    ON q.telebe_id = t.telebe_id
WHERE q.telebe_id IS NULL
ORDER BY t.telebe_id;

-- B10 (b): NOT EXISTS varianti.
SELECT
    t.telebe_id,
    t.telebe_adi
FROM akademiya_online.telebeler t
WHERE NOT EXISTS (
    SELECT 1
    FROM akademiya_online.qeydiyyatlar q
    WHERE q.telebe_id = t.telebe_id
)
ORDER BY t.telebe_id;

-- B10 (c): alt sorguda NULL oldugu ucun her muqayise FALSE ve ya
-- UNKNOWN olur; WHERE yalniz TRUE saxladigi ucun netice 0 setirdir.
SELECT
    t.telebe_id,
    t.telebe_adi
FROM akademiya_online.telebeler t
WHERE t.telebe_id NOT IN (
    SELECT q.telebe_id
    FROM akademiya_online.qeydiyyatlar q
    UNION ALL
    SELECT NULL::VARCHAR(10)
)
ORDER BY t.telebe_id;

-- B10 (d): kursu olmayan fenn.
SELECT
    f.fenn_kodu,
    f.fenn_adi
FROM akademiya_online.fennler f
LEFT JOIN akademiya_online.kurslar k
    ON k.fenn_kodu = f.fenn_kodu
WHERE k.kurs_kodu IS NULL;

-- B10 (d): otagi olmayan filial.
SELECT
    f.filial_kodu,
    f.filial_unvani
FROM akademiya_online.filiallar f
LEFT JOIN akademiya_online.otaqlar o
    ON o.filial_kodu = f.filial_kodu
WHERE o.otaq_no IS NULL;

-- ===== Tapşırıq B11 =====
-- B11 (a), EXISTS: her telebe maksimum bir defe qayidir.
SELECT
    t.telebe_id,
    t.telebe_adi
FROM akademiya_online.telebeler t
WHERE EXISTS (
    SELECT 1
    FROM akademiya_online.qeydiyyatlar q
    WHERE q.telebe_id = t.telebe_id
)
ORDER BY t.telebe_id;

-- B11 (a), IN.
SELECT
    t.telebe_id,
    t.telebe_adi
FROM akademiya_online.telebeler t
WHERE t.telebe_id IN (
    SELECT q.telebe_id
    FROM akademiya_online.qeydiyyatlar q
)
ORDER BY t.telebe_id;

-- B11 (a), INNER JOIN + DISTINCT.
SELECT DISTINCT
    t.telebe_id,
    t.telebe_adi
FROM akademiya_online.telebeler t
JOIN akademiya_online.qeydiyyatlar q
    ON q.telebe_id = t.telebe_id
ORDER BY t.telebe_id;

-- B11 (b): INNER JOIN her qeydiyyat ucun telebe setrini tekrar edir,
-- ona gore yalniz telebe siyahisi ucun DISTINCT lazimdir. SUM kimi
-- hesablamada DISTINCT tekrar gorunen eyni meblegleri de sile biler ve
-- dogru cemi sehv azalda biler. EXISTS/IN movcudlugu yoxlayir, sag
-- terefdeki setir sayini neticeye coxaltmir.

-- B11 (c): qiymeti 400-den yuxari kursa yazilan telebeler.
SELECT
    t.telebe_id,
    t.telebe_adi
FROM akademiya_online.telebeler t
WHERE EXISTS (
    SELECT 1
    FROM akademiya_online.qeydiyyatlar q
    JOIN akademiya_online.kurslar k
        ON k.kurs_kodu = q.kurs_kodu
    WHERE q.telebe_id = t.telebe_id
      AND k.qiymet > 400
)
ORDER BY t.telebe_id;

-- ===== Tapşırıq B12 =====
-- B12 (a): LATERAL alt-sorgu cari kursun kodunu gorur ve hemin kurs
-- uzre ilk 2 neticeni sechir. LEFT JOIN sebebinden neticesiz PYT-305
-- de NULL telebe ve bal ile bir setir kimi qalir.
SELECT
    k.kurs_kodu,
    k.kurs_adi,
    top_netice.telebe_adi,
    top_netice.imtahan_bali
FROM akademiya_online.kurslar k
LEFT JOIN LATERAL (
    SELECT
        t.telebe_adi,
        i.imtahan_bali
    FROM akademiya_online.imtahan_neticeleri i
    JOIN akademiya_online.telebeler t
        ON t.telebe_id = i.telebe_id
    WHERE i.kurs_kodu = k.kurs_kodu
    ORDER BY i.imtahan_bali DESC, i.telebe_id
    LIMIT 2
) top_netice ON TRUE
ORDER BY k.kurs_kodu, top_netice.imtahan_bali DESC NULLS LAST;

-- B12 (b): her filial ucun en son qeydiyyat.
SELECT
    f.filial_kodu,
    f.filial_unvani,
    son_qeydiyyat.telebe_id,
    son_qeydiyyat.kurs_kodu,
    son_qeydiyyat.qeydiyyat_tarixi
FROM akademiya_online.filiallar f
LEFT JOIN LATERAL (
    SELECT
        q.telebe_id,
        q.kurs_kodu,
        q.qeydiyyat_tarixi
    FROM akademiya_online.otaqlar o
    JOIN akademiya_online.qeydiyyatlar q
        ON q.otaq_no = o.otaq_no
    WHERE o.filial_kodu = f.filial_kodu
    ORDER BY q.qeydiyyat_tarixi DESC, q.telebe_id, q.kurs_kodu
    LIMIT 1
) son_qeydiyyat ON TRUE
ORDER BY f.filial_kodu;

-- B12 (c): ROW_NUMBER butun neticeleri kurs daxilinde siralayir, sonra
-- ilk ikisini saxlayir. LATERAL her xarici kurs ucun ayrica top-N ala
-- bilir; adi alt-sorgu LATERAL olmadan xarici k.kurs_kodu sutununa
-- muraciet ede bilmir.
WITH siralanmish_neticeler AS (
    SELECT
        i.kurs_kodu,
        t.telebe_adi,
        i.imtahan_bali,
        ROW_NUMBER() OVER (
            PARTITION BY i.kurs_kodu
            ORDER BY i.imtahan_bali DESC, i.telebe_id
        ) AS sira
    FROM akademiya_online.imtahan_neticeleri i
    JOIN akademiya_online.telebeler t
        ON t.telebe_id = i.telebe_id
)
SELECT
    k.kurs_kodu,
    k.kurs_adi,
    s.telebe_adi,
    s.imtahan_bali
FROM akademiya_online.kurslar k
LEFT JOIN siralanmish_neticeler s
    ON s.kurs_kodu = k.kurs_kodu
   AND s.sira <= 2
ORDER BY k.kurs_kodu, s.imtahan_bali DESC NULLS LAST;

-- ===== Tapşırıq B13 =====
-- B13 (a): F-03 elaqeli setri olmadigi ucun saylar ve gelir 0-dir.
SELECT
    f.filial_kodu,
    f.filial_unvani,
    COUNT(DISTINCT o.otaq_no) AS otaq_sayi,
    COUNT(DISTINCT q.telebe_id) AS unikal_telebe_sayi,
    COUNT(DISTINCT q.kurs_kodu) AS kurs_sayi,
    COALESCE(SUM(q.odenis), 0) AS umumi_gelir
FROM akademiya_online.filiallar f
LEFT JOIN akademiya_online.otaqlar o
    ON o.filial_kodu = f.filial_kodu
LEFT JOIN akademiya_online.qeydiyyatlar q
    ON q.otaq_no = o.otaq_no
GROUP BY f.filial_kodu, f.filial_unvani
ORDER BY f.filial_kodu;

-- B13 (b): aqreqat neticesi HAVING ile filtrlənir.
SELECT
    f.filial_kodu,
    f.filial_unvani,
    COUNT(DISTINCT o.otaq_no) AS otaq_sayi,
    COUNT(DISTINCT q.telebe_id) AS unikal_telebe_sayi,
    COUNT(DISTINCT q.kurs_kodu) AS kurs_sayi,
    COALESCE(SUM(q.odenis), 0) AS umumi_gelir
FROM akademiya_online.filiallar f
LEFT JOIN akademiya_online.otaqlar o
    ON o.filial_kodu = f.filial_kodu
LEFT JOIN akademiya_online.qeydiyyatlar q
    ON q.otaq_no = o.otaq_no
GROUP BY f.filial_kodu, f.filial_unvani
HAVING COALESCE(SUM(q.odenis), 0) > 1000
ORDER BY f.filial_kodu;

-- B13 (c): COUNT(*) LEFT JOIN-un yaratdigi T-04 setrini sayib 1 verir.
-- COUNT(q.kurs_kodu) NULL-i saymadigi ucun T-04 ucun dogru olaraq 0-dir.
SELECT
    t.telebe_id,
    t.telebe_adi,
    COUNT(*) AS count_all,
    COUNT(q.kurs_kodu) AS qeydiyyat_sayi
FROM akademiya_online.telebeler t
LEFT JOIN akademiya_online.qeydiyyatlar q
    ON q.telebe_id = t.telebe_id
GROUP BY t.telebe_id, t.telebe_adi
ORDER BY t.telebe_id;

-- ================================================================
-- HISSE C - NORMALIZASIYA VE JOIN-IN BIRLESHDIYI YER
-- ================================================================

-- ===== Tapşırıq C1 =====
-- Telefon ve dil evvelce ayrica aqreqasiya olunur. Eks halda iki
-- coxdeyerli cedveli birbasha JOIN etmek telefon x dil Dekart hasili
-- yaradib STRING_AGG daxilinde deyerleri tekrar etdirerdi.
CREATE OR REPLACE VIEW akademiya_online.v_kurs_qeydiyyat AS
WITH telefonlar AS (
    SELECT
        telebe_id,
        STRING_AGG(telefon, ', ' ORDER BY sira) AS telefonlar
    FROM akademiya_online.telebe_telefonlari
    GROUP BY telebe_id
),
muellim_dilleri AS (
    SELECT
        muellim_id,
        STRING_AGG(dil, ', ' ORDER BY dil) AS muellim_dilleri
    FROM akademiya_online.muellim_dilleri
    GROUP BY muellim_id
)
SELECT
    t.telebe_id,
    t.telebe_adi AS telebe_ad,
    t.dogum_tarixi,
    tel.telefonlar,
    k.kurs_kodu AS kurs_kod,
    k.kurs_adi AS kurs_ad,
    k.kurs_saati AS kurs_saat,
    k.qiymet,
    f.fenn_kodu AS fenn_kod,
    f.fenn_adi AS fenn_ad,
    m.muellim_id,
    m.muellim_adi AS muellim_ad,
    m.email AS muellim_email,
    md.muellim_dilleri,
    o.otaq_no,
    o.tutum AS otaq_tutum,
    fl.filial_kodu AS filial_kod,
    fl.filial_unvani AS filial_unvan,
    fl.seher,
    q.qeydiyyat_tarixi AS qeyd_tarixi,
    q.odenis,
    i.imtahan_bali
FROM akademiya_online.qeydiyyatlar q
JOIN akademiya_online.telebeler t
    ON t.telebe_id = q.telebe_id
LEFT JOIN telefonlar tel
    ON tel.telebe_id = t.telebe_id
JOIN akademiya_online.kurslar k
    ON k.kurs_kodu = q.kurs_kodu
JOIN akademiya_online.fennler f
    ON f.fenn_kodu = k.fenn_kodu
JOIN akademiya_online.muellimler m
    ON m.muellim_id = q.muellim_id
LEFT JOIN muellim_dilleri md
    ON md.muellim_id = m.muellim_id
JOIN akademiya_online.otaqlar o
    ON o.otaq_no = q.otaq_no
JOIN akademiya_online.filiallar fl
    ON fl.filial_kodu = o.filial_kodu
LEFT JOIN akademiya_online.imtahan_neticeleri i
    ON i.telebe_id = q.telebe_id
   AND i.kurs_kodu = q.kurs_kodu;

SELECT *
FROM akademiya_online.v_kurs_qeydiyyat
ORDER BY telebe_id, kurs_kod;

-- Izah: ilkin gorunushu qurmaq ucun 10 cedvel birleshdirildi.
-- Telefon, muellim dili ve imtahan neticesi olmayan qeydiyyatin
-- itmemesi ucun hemin cedveller LEFT JOIN olundu. Normallasdirma
-- INSERT/UPDATE/DELETE ve butovluyu ucuzlashdirdi, oxu sorgularini ise
-- daha cox JOIN teleb etdiyi ucun bahalashdirdi.

-- ===== Tapşırıq C2 =====
-- C2 (a): 3 proyeksiya + muellimler + filiallar = 5 cedvel.
SELECT
    mk.muellim_id,
    m.muellim_adi,
    mk.kurs_kodu,
    mf.filial_kodu,
    f.filial_unvani
FROM akademiya_online.muellim_kurs mk
JOIN akademiya_online.kurs_filial kf
    ON kf.kurs_kodu = mk.kurs_kodu
JOIN akademiya_online.muellim_filial mf
    ON mf.muellim_id = mk.muellim_id
   AND mf.filial_kodu = kf.filial_kodu
JOIN akademiya_online.muellimler m
    ON m.muellim_id = mk.muellim_id
JOIN akademiya_online.filiallar f
    ON f.filial_kodu = mf.filial_kodu
ORDER BY mk.muellim_id, mk.kurs_kodu, mf.filial_kodu;

-- C2 (b): iki cedvelin JOIN-i artiq M-11, SQL-101, F-02 setrini
-- qaytarir. Bu setir M-11 muelliminin F-02 filialinda ishlememesine
-- baxmayaraq orada SQL-101 tedris etdiyini sehv iddia edir.
SELECT
    mk.muellim_id,
    mk.kurs_kodu,
    kf.filial_kodu
FROM akademiya_online.muellim_kurs mk
JOIN akademiya_online.kurs_filial kf
    ON kf.kurs_kodu = mk.kurs_kodu
ORDER BY mk.muellim_id, mk.kurs_kodu, kf.filial_kodu;

-- ===== Tapşırıq C3 =====
-- C3 (a), UPDATE anomaliyasi: normallasdirilmamis cedvelde M-05-in
-- e-poctu 3 setrde tekrarlandigi ucun 3 UPDATE teleb olunur.
-- Normallasdirilmis sxemde muellim bir setirdedir, ona gore 1 setir
-- deyishir. ROLLBACK testden sonra ilkin deyeri berpa edir.
BEGIN;

UPDATE akademiya_online.muellimler
SET email = 'reshad.quliyev@akademiya.az'
WHERE muellim_id = 'M-05'
RETURNING muellim_id, muellim_adi, email;

ROLLBACK;

-- C3 (b), INSERT anomaliyasi: ilkin cedvelde telebe_id, kurs_kodu,
-- muellim_id ve qeydiyyat sahələri mecburi oldugu ucun hele kursu ve
-- telebesi olmayan fenni ayrica yazmaq mumkun deyil. Normallasdirilmis
-- sxemde fennler cedveline 1 setir elave etmek kifayetdir.
BEGIN;

INSERT INTO akademiya_online.fennler (fenn_kodu, fenn_adi)
VALUES ('F-KIB', 'Kibertəhlükəsizlik')
RETURNING fenn_kodu, fenn_adi;

ROLLBACK;

-- C3 (c), DELETE anomaliyasi: normallasdirilmamis cedvelde T-03-un
-- DSC-301 setri silinse DSC-301 kursu, F-DSC fenni, M-09 muellimi ve
-- B-410 otagi haqqinda yegane faktlar da itir. Normallasdirilmis sxemde
-- yalnız qeydiyyat silinir; kurs ve diger faktlar qalir.
BEGIN;

DELETE FROM akademiya_online.qeydiyyatlar
WHERE telebe_id = 'T-03'
  AND kurs_kodu = 'DSC-301'
RETURNING telebe_id, kurs_kodu;

SELECT kurs_kodu, kurs_adi
FROM akademiya_online.kurslar
WHERE kurs_kodu = 'DSC-301';

ROLLBACK;

-- Netice: (a) UPDATE, (b) INSERT, (c) DELETE anomaliyasidir.

-- ================================================================
-- BONUS
-- ================================================================

-- ===== Tapşırıq Bonus (a) =====
-- Kicik test melumatinda planner adeten Hash Join ve Nested Loop
-- seche biler. Konkret plan statistika, indeks ve PostgreSQL versiyasina
-- gore deyishdiyi ucun ashagidaki real EXPLAIN neticesi esas goturulur.
ANALYZE akademiya_online.telebeler;
ANALYZE akademiya_online.telebe_telefonlari;
ANALYZE akademiya_online.kurslar;
ANALYZE akademiya_online.fennler;
ANALYZE akademiya_online.muellimler;
ANALYZE akademiya_online.muellim_dilleri;
ANALYZE akademiya_online.otaqlar;
ANALYZE akademiya_online.filiallar;
ANALYZE akademiya_online.qeydiyyatlar;
ANALYZE akademiya_online.imtahan_neticeleri;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM akademiya_online.v_kurs_qeydiyyat;

-- ===== Tapşırıq Bonus (b) =====
-- Hash Join sonduruldukde planner eyni elaqeler ucun Nested Loop ve ya
-- Merge Join seche biler. Parametr testden sonra mutleq berpa olunur.
SET enable_hashjoin = OFF;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM akademiya_online.v_kurs_qeydiyyat;

SET enable_hashjoin = ON;

-- ===== Tapşırıq Bonus (c) =====
CREATE INDEX idx_qeydiyyat_muellim
    ON akademiya_online.qeydiyyatlar (muellim_id);

ANALYZE akademiya_online.qeydiyyatlar;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM akademiya_online.v_kurs_qeydiyyat;

-- Izah: qeydiyyatlar cedvelinde cemi 7 setir oldugu ucun butun sehifeni
-- ardicil oxuyan Seq Scan indeksden istifade etmekden daha ucuzdur.
-- Cedvel boyudukde ve muellim_id uzre sechicilik kifayet etdikde indeks
-- JOIN ve filtr sorgularinda fayda vere biler.

-- ===== Tapşırıq Bonus (d) =====
-- Trigger testi: T-04 SQL fenni olan SQL-101 kursuna Python fenni
-- tedris eden M-07 ile yazilmaq isteyir. Trigger 23514 xetasi atir,
-- daxili exception bloku ise gozlenilen xetani tutub skripti davam etdirir.
DO $$
BEGIN
    BEGIN
        INSERT INTO akademiya_online.qeydiyyatlar (
            telebe_id, kurs_kodu, muellim_id, otaq_no,
            qeydiyyat_tarixi, odenis
        )
        VALUES (
            'T-04', 'SQL-101', 'M-07', 'A-201', DATE '2025-03-15', 350
        );

        RAISE EXCEPTION 'Trigger qayda pozuntusunu saxlamadi';
    EXCEPTION
        WHEN check_violation THEN
            RAISE WARNING 'Gozlenilen 23514 xetasi alindi: %', SQLERRM;
    END;
END;
$$;

-- Trigger-in ikinci qaydasi: telebenin eyni fenn uzre iki ferqli
-- muellimi ola bilmez. Bu test 23505 xetasini gozleyir.
DO $$
BEGIN
    BEGIN
        INSERT INTO akademiya_online.qeydiyyatlar (
            telebe_id, kurs_kodu, muellim_id, otaq_no,
            qeydiyyat_tarixi, odenis
        )
        VALUES (
            'T-01', 'SQL-202', 'M-11', 'B-305', DATE '2025-03-16', 450
        );

        RAISE EXCEPTION 'Trigger iten funksional asililigi saxlamadi';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE WARNING 'Gozlenilen 23505 xetasi alindi: %', SQLERRM;
    END;
END;
$$;

SELECT
    (SELECT COUNT(*) FROM akademiya_online.telebeler) AS telebe_sayi,
    (SELECT COUNT(*) FROM akademiya_online.kurslar) AS kurs_sayi,
    (SELECT COUNT(*) FROM akademiya_online.muellimler) AS muellim_sayi,
    (SELECT COUNT(*) FROM akademiya_online.qeydiyyatlar) AS qeydiyyat_sayi,
    (SELECT COUNT(*) FROM akademiya_online.imtahan_neticeleri) AS imtahan_sayi;
