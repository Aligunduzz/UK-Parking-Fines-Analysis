-- Tabloyu görüntüleme
-- sonuc2 tablosundaki tüm kayýtlarý ve sütunlarý görüntüler.
SELECT
*
FROM
sonuc2;


-- Sütun veri tipini deðiþtirme
-- Income_per_PCN sütununu iki ondalýk basamak içeren DECIMAL veri tipine dönüþtürür.
ALTER TABLE sonuc2
ALTER COLUMN [Income_per_PCN] DECIMAL(10,2);


-- Güncellenmiþ tabloyu kontrol etme
-- ALTER COLUMN iþleminden sonra tablonun güncel halini görüntüler.
SELECT
*
FROM
sonuc2;

-- Toplam PCN sayýsýný hesaplama
-- Veri setindeki toplam Penalty Charge Notice sayýsýný hesaplar.
SELECT
SUM(Penalty_Charge_Notices_Issued)
FROM sonuc2;


-- Toplam PCN gelirini hesaplama
-- Tüm dönemlerdeki toplam PCN gelirini hesaplar.
SELECT
SUM(On_Off_Street_Income_from_PCNs)
FROM sonuc2;


-- Ortalama PCN sayýsýný hesaplama
-- Aylýk ortalama Penalty Charge Notice sayýsýný hesaplar.
SELECT
AVG(Penalty_Charge_Notices_Issued)
FROM sonuc2;


-- Ortalama PCN gelirini hesaplama
-- Aylýk ortalama PCN gelirini hesaplar.
SELECT
AVG(On_Off_Street_Income_from_PCNs)
FROM sonuc2;


-- En yüksek PCN sayýsýna sahip ayý bulma
-- En fazla Penalty Charge Notice verilen dönemi ve ilgili tüm bilgileri getirir.
SELECT TOP 1 *
FROM sonuc2
ORDER BY Penalty_Charge_Notices_Issued DESC;


-- En yüksek PCN gelirine sahip ayý bulma
-- PCN gelirinin en yüksek olduðu dönemi ve ilgili tüm bilgileri getirir.
SELECT TOP 1 *
FROM sonuc2
ORDER BY On_Off_Street_Income_from_PCNs DESC;


-- En düþük PCN sayýsýna sahip ayý bulma
-- En az Penalty Charge Notice verilen dönemi ve ilgili tüm bilgileri getirir.
SELECT TOP 1 *
FROM sonuc2
ORDER BY Penalty_Charge_Notices_Issued ASC;


-- En düþük PCN gelirine sahip ayý bulma
-- PCN gelirinin en düþük olduðu dönemi ve ilgili tüm bilgileri getirir.
SELECT TOP 1 *
FROM sonuc2
ORDER BY On_Off_Street_Income_from_PCNs ASC;

-- PCN sayýsýnýn en yüksek olduðu ayý bulma
-- En fazla Penalty Charge Notice verilen ayýn adýný getirir.
SELECT TOP 1 Month
FROM sonuc2
ORDER BY Penalty_Charge_Notices_Issued DESC;


-- PCN gelirinin en yüksek olduðu ayý bulma
-- En yüksek PCN gelirinin elde edildiði ayýn adýný getirir.
SELECT TOP 1 Month
FROM sonuc2
ORDER BY On_Off_Street_Income_from_PCNs DESC;


-- Aylýk PCN sayýsý deðiþimini hesaplama
-- Her ayýn PCN sayýsýný bir önceki ay ile karþýlaþtýrýr.
SELECT
    Month,
    Penalty_Charge_Notices_Issued,
    Penalty_Charge_Notices_Issued
        - LAG(Penalty_Charge_Notices_Issued) OVER (ORDER BY Month)
        AS Degisim
FROM sonuc2
ORDER BY Month;



-- Gelirdeki en yüksek aylýk yüzde deðiþimi bulma
-- Her ayýn PCN gelirini önceki ayla karþýlaþtýrýr ve en yüksek artýþýn olduðu ayý bulur.
WITH cte AS (
    SELECT
        Month,
        On_Off_Street_Income_from_PCNs,
        CAST(
            (
                On_Off_Street_Income_from_PCNs * 1.0
                / LAG(On_Off_Street_Income_from_PCNs) OVER (ORDER BY Month)
                - 1
            ) * 100
            AS DECIMAL(10,2)
        ) AS Degisim_Yuzdesi
    FROM sonuc2
)
SELECT TOP 1 *
FROM cte
ORDER BY Degisim_Yuzdesi DESC;



-- PCN baþýna ortalama geliri hesaplama
-- Her ay elde edilen toplam geliri PCN sayýsýna bölerek bir PCN'den elde edilen ortalama geliri hesaplar.
SELECT 
    Month,
    On_Off_Street_Income_from_PCNs / Penalty_Charge_Notices_Issued AS PCN_Basina_Ortalama_Gelir
FROM sonuc2;


-- PCN baþýna gelirin en düþük olduðu ayý bulma
-- Bir PCN'den elde edilen ortalama gelirin en düþük olduðu ayý bulur.
SELECT TOP 1
    Month,
    On_Off_Street_Income_from_PCNs / Penalty_Charge_Notices_Issued AS PCN_Basina_Ortalama_Gelir
FROM sonuc2
ORDER BY On_Off_Street_Income_from_PCNs / Penalty_Charge_Notices_Issued ASC;



-- PCN baþýna gelirin en yüksek olduðu ayý bulma
-- Bir PCN'den elde edilen ortalama gelirin en yüksek olduðu ayý bulur.
SELECT TOP 1
    Month,
    On_Off_Street_Income_from_PCNs / Penalty_Charge_Notices_Issued AS PCN_Basina_Ortalama_Gelir
FROM sonuc2
ORDER BY On_Off_Street_Income_from_PCNs / Penalty_Charge_Notices_Issued DESC;




-- PCN sayýsý ve gelirin aylýk yüzde deðiþimini karþýlaþtýrma
-- PCN sayýsýndaki ve gelirdeki aylýk yüzde deðiþimleri hesaplayarak
-- iki deðiþkenin ayný oranda artýp artmadýðýný analiz eder.
SELECT
    Month,
    Penalty_Charge_Notices_Issued,
    On_Off_Street_Income_from_PCNs,

    CAST(
        (
            Penalty_Charge_Notices_Issued * 1.0
            / LAG(Penalty_Charge_Notices_Issued) OVER (ORDER BY Month)
            - 1
        ) * 100
        AS DECIMAL(10,2)
    ) AS PCN_Degisim_Yuzdesi,

    CAST(
        (
            On_Off_Street_Income_from_PCNs * 1.0
            / LAG(On_Off_Street_Income_from_PCNs) OVER (ORDER BY Month)
            - 1
        ) * 100
        AS DECIMAL(10,2)
    ) AS Gelir_Degisim_Yuzdesi

FROM sonuc2
ORDER BY Month;





-- Yýllara göre toplam PCN sayýsýný hesaplama
-- Her yýl verilen toplam Penalty Charge Notice sayýsýný hesaplar.
SELECT
YEAR(Month) as yil,
SUM(Penalty_Charge_Notices_Issued) as bildirilen_ceza
FROM sonuc2
GROUP BY YEAR(Month)
ORDER BY YEAR(Month);



-- Yýllara göre toplam PCN gelirini hesaplama
-- Her yýl elde edilen toplam PCN gelirini hesaplar.
SELECT
YEAR(Month) AS yil,
SUM(On_Off_Street_Income_from_PCNs) AS gelir
FROM sonuc2
GROUP BY YEAR(Month)
ORDER BY YEAR(Month);




-- Yýllýk PCN sayýsý ve yüzde deðiþimini hesaplama
-- Her yýlýn toplam PCN sayýsýný önceki yýl ile karþýlaþtýrýr
-- ve yýllýk yüzde deðiþimi hesaplar.
WITH yillik AS (
    SELECT
        YEAR(Month) AS yil,
        SUM(Penalty_Charge_Notices_Issued) AS toplam
    FROM sonuc2
    GROUP BY YEAR(Month)
)
SELECT
    yil,
    toplam,
    LAG(toplam) OVER (ORDER BY yil) AS onceki_yil,
    (
        (toplam - LAG(toplam) OVER (ORDER BY yil)) * 100.0
        / LAG(toplam) OVER (ORDER BY yil)
    ) AS yuzdelik_degisim
FROM yillik
ORDER BY yil;






-- Yýllýk PCN geliri ve yüzde deðiþimini hesaplama
-- Her yýlýn toplam PCN gelirini önceki yýl ile karþýlaþtýrýr
-- ve yýllýk yüzde deðiþimi hesaplar.
WITH yillik AS (
    SELECT
        YEAR(Month) AS yil,
        SUM(On_Off_Street_Income_from_PCNs) AS toplam
    FROM sonuc2
    GROUP BY YEAR(Month)
)
SELECT
    yil,
    toplam,
    LAG(toplam) OVER (ORDER BY yil) AS onceki_yil,
    (
        (toplam - LAG(toplam) OVER (ORDER BY yil)) * 100.0
        / LAG(toplam) OVER (ORDER BY yil)
    ) AS yuzdelik_degisim
FROM yillik
ORDER BY yil;




