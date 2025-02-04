USE [Karsiyaka]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculatePaymentAmount]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculatePaymentAmount]
(
    @sepet_id INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @totalAmount DECIMAL(10, 2);

    SELECT @totalAmount = SUM(adet * fiyat)
    FROM sepet s
    INNER JOIN forma f ON s.urun_id = f.urun_id
    WHERE s.sepet_id = @sepet_id;

    RETURN @totalAmount;
END;

GO
/****** Object:  UserDefinedFunction [dbo].[GetMonthlySalesCount]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetMonthlySalesCount]
(
    @ay INT,
    @sehir_adi NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
    DECLARE @totalSalesCount INT;

    SELECT @totalSalesCount = COUNT(*)
    FROM satislar s
    INNER JOIN sepet sp ON s.sepet_id = sp.sepet_id
    INNER JOIN musteri m ON sp.musteri_id = m.musteri_id
    INNER JOIN personel p ON s.personel_id = p.personel_id
    INNER JOIN sehirler sh ON p.sehir_id = sh.sehir_id
    WHERE MONTH(s.tarih) = @ay AND sh.sehir_adi = @sehir_adi;

    RETURN @totalSalesCount;
END;

GO
/****** Object:  Table [dbo].[sehirler]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sehirler](
	[sehir_id] [int] NOT NULL,
	[sehir_adi] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sehir_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[personel]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[personel](
	[personel_id] [int] NOT NULL,
	[sehir_id] [int] NULL,
	[personel_adi] [nvarchar](50) NOT NULL,
	[personel_soyadi] [nvarchar](50) NOT NULL,
	[personel_dogum_tarihi] [date] NOT NULL,
	[personel_tc] [int] NULL,
	[personel_mail] [nvarchar](50) NOT NULL,
	[personel_tel_no] [int] NOT NULL,
	[personel_cinsiyet] [bit] NULL,
	[personel_sifre] [nvarchar](50) NOT NULL,
	[personel_maas] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[personel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPersonelInCity]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetPersonelInCity]
(
    @sehir_adi NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT p.personel_id, p.personel_adi, p.personel_soyadi, s.sehir_adi
    FROM personel p
    INNER JOIN sehirler s ON p.sehir_id = s.sehir_id
    WHERE s.sehir_adi = @sehir_adi
);

GO
/****** Object:  Table [dbo].[musteri]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[musteri](
	[musteri_id] [int] NOT NULL,
	[sehir_id] [int] NULL,
	[musteri_adi] [nvarchar](50) NOT NULL,
	[musteri_soyadi] [nvarchar](50) NULL,
	[musteri_dogum_tarihi] [date] NOT NULL,
	[musteri_tc] [int] NULL,
	[musteri_mail] [nvarchar](50) NULL,
	[musteri_tel_no] [int] NULL,
	[musteri_cinsiyet] [bit] NULL,
	[musteri_sifre] [nvarchar](50) NULL,
	[musteri_kullanici_adi] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[musteri_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sepet]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sepet](
	[sepet_id] [int] NOT NULL,
	[musteri_id] [int] NOT NULL,
	[urun_id] [int] NOT NULL,
	[adet] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sepet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[satislar]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[satislar](
	[satis_id] [int] NOT NULL,
	[sepet_id] [int] NULL,
	[personel_id] [int] NULL,
	[tarih] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[satis_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetSalesByDate]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetSalesByDate]
(
    @tarih DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT s.satis_id, s.tarih, m.musteri_adi, m.musteri_soyadi, p.personel_adi, p.personel_soyadi
    FROM satislar s
    INNER JOIN sepet sp ON s.sepet_id = sp.sepet_id
    INNER JOIN musteri m ON sp.musteri_id = m.musteri_id
    INNER JOIN personel p ON s.personel_id = p.personel_id
    WHERE s.tarih = @tarih
);

GO
/****** Object:  Table [dbo].[backup_personel]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[backup_personel](
	[personel_id] [int] NOT NULL,
	[sehir_id] [int] NULL,
	[personel_adi] [nvarchar](50) NOT NULL,
	[personel_soyadi] [nvarchar](50) NOT NULL,
	[personel_dogum_tarihi] [date] NOT NULL,
	[personel_tc] [char](11) NOT NULL,
	[personel_mail] [nvarchar](50) NOT NULL,
	[personel_tel_no] [int] NOT NULL,
	[personel_cinsiyet] [bit] NOT NULL,
	[personel_sifre] [nvarchar](50) NOT NULL,
	[personel_maas] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[personel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[corap]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corap](
	[corap_id] [int] NOT NULL,
	[urun_id] [int] NOT NULL,
	[corap_beden] [nvarchar](50) NOT NULL,
	[corap_ad] [nvarchar](50) NOT NULL,
	[fiyat] [int] NOT NULL,
	[stok] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[corap_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[deleted_personel]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[deleted_personel](
	[personel_id] [int] NOT NULL,
	[sehir_id] [int] NULL,
	[personel_adi] [nvarchar](50) NOT NULL,
	[personel_soyadi] [nvarchar](50) NOT NULL,
	[personel_dogum_tarihi] [date] NOT NULL,
	[personel_tc] [char](11) NOT NULL,
	[personel_mail] [nvarchar](50) NOT NULL,
	[personel_tel_no] [int] NOT NULL,
	[personel_cinsiyet] [bit] NOT NULL,
	[personel_maas] [int] NULL,
	[personel_sifre] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[personel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[forma]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[forma](
	[forma_id] [int] NOT NULL,
	[urun_id] [int] NOT NULL,
	[forma_beden] [nvarchar](50) NOT NULL,
	[forma_ad] [nvarchar](50) NOT NULL,
	[fiyat] [int] NOT NULL,
	[stok] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[forma_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[kargo]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kargo](
	[kargo_id] [int] NOT NULL,
	[musteri_id] [int] NULL,
	[takip_kodu] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[kargo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[kart]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kart](
	[odeme_id] [int] NOT NULL,
	[kart_bilgi] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[odeme_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[nakit]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nakit](
	[odeme_id] [int] NOT NULL,
	[nakit_bilgi] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[odeme_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[odeme]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[odeme](
	[odeme_id] [int] NOT NULL,
	[sepet_id] [int] NOT NULL,
	[odeme_tipi] [int] NOT NULL,
	[odeme_tutari] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[odeme_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sapka]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sapka](
	[sapka_id] [int] NOT NULL,
	[urun_id] [int] NOT NULL,
	[sapka_ad] [nvarchar](50) NOT NULL,
	[fiyat] [int] NOT NULL,
	[stok] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sapka_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[updated_personel]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[updated_personel](
	[personel_id] [int] NOT NULL,
	[sehir_id] [int] NULL,
	[personel_adi] [nvarchar](50) NOT NULL,
	[personel_soyadi] [nvarchar](50) NOT NULL,
	[personel_dogum_tarihi] [date] NOT NULL,
	[personel_tc] [char](11) NOT NULL,
	[personel_mail] [nvarchar](50) NOT NULL,
	[personel_tel_no] [int] NOT NULL,
	[personel_cinsiyet] [bit] NOT NULL,
	[personel_maas] [int] NULL,
	[personel_sifre] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[personel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[urunler]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[urunler](
	[urun_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[urun_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__kargo__980A6047FFCD2998]    Script Date: 9.05.2024 01:27:28 ******/
ALTER TABLE [dbo].[kargo] ADD UNIQUE NONCLUSTERED 
(
	[takip_kodu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__musteri__96690F9F54D2AC91]    Script Date: 9.05.2024 01:27:28 ******/
ALTER TABLE [dbo].[musteri] ADD UNIQUE NONCLUSTERED 
(
	[musteri_tc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__personel__48A6E55543BD4C4D]    Script Date: 9.05.2024 01:27:28 ******/
ALTER TABLE [dbo].[personel] ADD UNIQUE NONCLUSTERED 
(
	[personel_tc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[musteri] ADD  DEFAULT ((1)) FOR [musteri_cinsiyet]
GO
ALTER TABLE [dbo].[personel] ADD  DEFAULT ((1)) FOR [personel_cinsiyet]
GO
ALTER TABLE [dbo].[corap]  WITH CHECK ADD FOREIGN KEY([urun_id])
REFERENCES [dbo].[urunler] ([urun_id])
GO
ALTER TABLE [dbo].[forma]  WITH CHECK ADD FOREIGN KEY([urun_id])
REFERENCES [dbo].[urunler] ([urun_id])
GO
ALTER TABLE [dbo].[kargo]  WITH CHECK ADD FOREIGN KEY([musteri_id])
REFERENCES [dbo].[musteri] ([musteri_id])
GO
ALTER TABLE [dbo].[kart]  WITH CHECK ADD FOREIGN KEY([odeme_id])
REFERENCES [dbo].[odeme] ([odeme_id])
GO
ALTER TABLE [dbo].[musteri]  WITH CHECK ADD FOREIGN KEY([sehir_id])
REFERENCES [dbo].[sehirler] ([sehir_id])
GO
ALTER TABLE [dbo].[nakit]  WITH CHECK ADD FOREIGN KEY([odeme_id])
REFERENCES [dbo].[odeme] ([odeme_id])
GO
ALTER TABLE [dbo].[odeme]  WITH CHECK ADD FOREIGN KEY([sepet_id])
REFERENCES [dbo].[sepet] ([sepet_id])
GO
ALTER TABLE [dbo].[personel]  WITH CHECK ADD FOREIGN KEY([sehir_id])
REFERENCES [dbo].[sehirler] ([sehir_id])
GO
ALTER TABLE [dbo].[sapka]  WITH CHECK ADD FOREIGN KEY([urun_id])
REFERENCES [dbo].[urunler] ([urun_id])
GO
ALTER TABLE [dbo].[satislar]  WITH CHECK ADD FOREIGN KEY([personel_id])
REFERENCES [dbo].[personel] ([personel_id])
GO
ALTER TABLE [dbo].[satislar]  WITH CHECK ADD FOREIGN KEY([sepet_id])
REFERENCES [dbo].[sepet] ([sepet_id])
GO
ALTER TABLE [dbo].[sepet]  WITH CHECK ADD FOREIGN KEY([musteri_id])
REFERENCES [dbo].[musteri] ([musteri_id])
GO
ALTER TABLE [dbo].[sepet]  WITH CHECK ADD FOREIGN KEY([urun_id])
REFERENCES [dbo].[urunler] ([urun_id])
GO
ALTER TABLE [dbo].[musteri]  WITH CHECK ADD CHECK  (([musteri_dogum_tarihi]<=dateadd(year,(-18),getdate())))
GO
ALTER TABLE [dbo].[musteri]  WITH CHECK ADD CHECK  ((NOT [musteri_tc] like '0%'))
GO
ALTER TABLE [dbo].[personel]  WITH CHECK ADD CHECK  (([personel_dogum_tarihi]<=dateadd(year,(-18),getdate())))
GO
ALTER TABLE [dbo].[personel]  WITH CHECK ADD CHECK  ((NOT [personel_tc] like '0%'))
GO
/****** Object:  StoredProcedure [dbo].[DeletePersonel]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePersonel]
    @personel_id INT
AS
BEGIN
    DECLARE @sehir_id INT, @personel_adi NVARCHAR(50), @personel_soyadi NVARCHAR(50), @personel_dogum_tarihi DATE, @personel_tc CHAR(11), @personel_mail NVARCHAR(50), @personel_tel_no INT, @personel_cinsiyet BIT, @personel_sifre NVARCHAR(50), @personel_maas INT

    SELECT @sehir_id = sehir_id, @personel_adi = personel_adi, @personel_soyadi = personel_soyadi, @personel_dogum_tarihi = personel_dogum_tarihi, @personel_tc = personel_tc, @personel_mail = personel_mail, @personel_tel_no = personel_tel_no, @personel_cinsiyet = personel_cinsiyet, @personel_sifre = personel_sifre, @personel_maas = personel_maas
    FROM personel
    WHERE personel_id = @personel_id;

    INSERT INTO deleted_personel (personel_id, sehir_id, personel_adi, personel_soyadi, personel_dogum_tarihi, personel_tc, personel_mail, personel_tel_no, personel_cinsiyet, personel_sifre, personel_maas)
    VALUES (@personel_id, @sehir_id, @personel_adi, @personel_soyadi, @personel_dogum_tarihi, @personel_tc, @personel_mail, @personel_tel_no, @personel_cinsiyet, @personel_sifre, @personel_maas);

    DELETE FROM personel
    WHERE personel_id = @personel_id;
END;

GO
/****** Object:  StoredProcedure [dbo].[InsertPersonel]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertPersonel]
    @sehir_id INT,
    @personel_adi NVARCHAR(50),
    @personel_soyadi NVARCHAR(50),
    @personel_dogum_tarihi DATE,
    @personel_tc CHAR(11),
    @personel_mail NVARCHAR(50),
    @personel_tel_no INT,
    @personel_cinsiyet BIT,  
    @personel_sifre NVARCHAR(50),
    @personel_maas INT
AS
BEGIN
    INSERT INTO backup_personel (sehir_id, personel_adi, personel_soyadi, personel_dogum_tarihi, personel_tc, personel_mail, personel_tel_no, personel_cinsiyet, personel_sifre, personel_maas)
    VALUES (@sehir_id, @personel_adi, @personel_soyadi, @personel_dogum_tarihi, @personel_tc, @personel_mail, @personel_tel_no, @personel_cinsiyet, @personel_sifre, @personel_maas)
END;

GO
/****** Object:  StoredProcedure [dbo].[InsertRecordsTransaction]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertRecordsTransaction]
    @sehir_id INT,
    @personel_adi NVARCHAR(50),
    @personel_soyadi NVARCHAR(50),
    @personel_dogum_tarihi DATE,
    @personel_tc CHAR(11),
    @personel_mail NVARCHAR(50),
    @personel_tel_no INT,
    @personel_cinsiyet BIT,
    @personel_sifre NVARCHAR(50),
    @personel_maas INT,
    @musteri_adi NVARCHAR(50),
    @musteri_soyadi NVARCHAR(50),
    @musteri_dogum_tarihi DATE,
    @musteri_tc CHAR(11),
    @musteri_mail NVARCHAR(50),
    @musteri_tel_no INT,
    @musteri_cinsiyet BIT,
    @musteri_sifre NVARCHAR(50),
    @musteri_kullanici_adi NVARCHAR(50),
    @forma_beden NVARCHAR(50),
    @forma_ad NVARCHAR(50),
    @forma_fiyat INT,
    @forma_stok INT,
    @adet INT,
    @odeme_tipi INT,
    @odeme_tutari DECIMAL(10, 2),
    @tarih DATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insert into personel
        INSERT INTO personel (sehir_id, personel_adi, personel_soyadi, personel_dogum_tarihi, personel_tc, personel_mail, personel_tel_no, personel_cinsiyet, personel_sifre, personel_maas)
        VALUES (@sehir_id, @personel_adi, @personel_soyadi, @personel_dogum_tarihi, @personel_tc, @personel_mail, @personel_tel_no, @personel_cinsiyet, @personel_sifre, @personel_maas);

        DECLARE @personel_id INT;
        SET @personel_id = SCOPE_IDENTITY();

        -- Insert into musteri
        INSERT INTO musteri (sehir_id, musteri_adi, musteri_soyadi, musteri_dogum_tarihi, musteri_tc, musteri_mail, musteri_tel_no, musteri_cinsiyet, musteri_sifre, musteri_kullanici_adi)
        VALUES (@sehir_id, @musteri_adi, @musteri_soyadi, @musteri_dogum_tarihi, @musteri_tc, @musteri_mail, @musteri_tel_no, @musteri_cinsiyet, @musteri_sifre, @musteri_kullanici_adi);

        DECLARE @musteri_id INT;
        SET @musteri_id = SCOPE_IDENTITY();

        -- Insert into forma
        INSERT INTO forma (urun_id, forma_beden, forma_ad, fiyat, stok)
        VALUES (@personel_id, @forma_beden, @forma_ad, @forma_fiyat, @forma_stok);

        -- Insert into sepet
        DECLARE @sepet_id INT;
        INSERT INTO sepet (musteri_id, urun_id, adet)
        VALUES (@musteri_id, @personel_id, @adet);

        SET @sepet_id = SCOPE_IDENTITY();

        -- Insert into odeme
        INSERT INTO odeme (sepet_id, odeme_tipi, odeme_tutari)
        VALUES (@sepet_id, @odeme_tipi, @odeme_tutari);

        -- Insert into satislar
        INSERT INTO satislar (sepet_id, personel_id, tarih)
        VALUES (@sepet_id, @personel_id, @tarih);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Handle the error or raise it
        THROW;
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[UpdatePersonel]    Script Date: 9.05.2024 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePersonel]
    @personel_id INT,
    @sehir_id INT,
    @personel_adi NVARCHAR(50),
    @personel_soyadi NVARCHAR(50),
    @personel_dogum_tarihi DATE,
    @personel_tc CHAR(11),
    @personel_mail NVARCHAR(50),
    @personel_tel_no INT,
    @personel_cinsiyet BIT,
    @personel_sifre NVARCHAR(50),
    @personel_maas INT
AS
BEGIN
    DECLARE @prev_sehir_id INT, @prev_personel_adi NVARCHAR(50), @prev_personel_soyadi NVARCHAR(50), @prev_personel_dogum_tarihi DATE, @prev_personel_tc CHAR(11), @prev_personel_mail NVARCHAR(50), @prev_personel_tel_no INT, @prev_personel_cinsiyet BIT, @prev_personel_sifre NVARCHAR(50), @prev_personel_maas INT

    SELECT @prev_sehir_id = sehir_id, @prev_personel_adi = personel_adi, @prev_personel_soyadi = personel_soyadi, @prev_personel_dogum_tarihi = personel_dogum_tarihi, @prev_personel_tc = personel_tc, @prev_personel_mail = personel_mail, @prev_personel_tel_no = personel_tel_no, @prev_personel_cinsiyet = personel_cinsiyet, @prev_personel_sifre = personel_sifre, @prev_personel_maas = personel_maas
    FROM personel
    WHERE personel_id = @personel_id;

    INSERT INTO updated_personel (personel_id, sehir_id, personel_adi, personel_soyadi, personel_dogum_tarihi, personel_tc, personel_mail, personel_tel_no, personel_cinsiyet, personel_sifre, personel_maas)
    VALUES (@personel_id, @prev_sehir_id, @prev_personel_adi, @prev_personel_soyadi, @prev_personel_dogum_tarihi, @prev_personel_tc, @prev_personel_mail, @prev_personel_tel_no, @prev_personel_cinsiyet, @prev_personel_sifre, @prev_personel_maas);

    UPDATE personel
    SET sehir_id = @sehir_id, personel_adi = @personel_adi, personel_soyadi = @personel_soyadi, personel_dogum_tarihi = @personel_dogum_tarihi, personel_tc = @personel_tc, personel_mail = @personel_mail, personel_tel_no = @personel_tel_no, personel_cinsiyet = @personel_cinsiyet, personel_sifre = @personel_sifre, personel_maas = @personel_maas
    WHERE personel_id = @personel_id;
END;

GO
