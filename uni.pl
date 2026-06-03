% ==========================================
% AKILLI ÖĞRENCİ BİLGİ SİSTEMİ
% ==========================================

:- dynamic not_bilgisi/4.

% --- OLGULAR ---
not_bilgisi(gokcen, programlama1, 40, 50). 
not_bilgisi(gokcen, matematik1, 75, 80).   
not_bilgisi(omer, programlama1, 85, 90).   

onkosul(programlama2, programlama1).
onkosul(matematik2, matematik1).
onkosul(veri_yapilari, programlama1).

% --- MATEMATİK VE KARAR KURALLARI ---
ortalama(Ogrenci, Ders, Ort) :-
    not_bilgisi(Ogrenci, Ders, Vize, Final),
    Ort is (Vize * 0.4) + (Final * 0.6).

gecti(Ogrenci, Ders) :-
    ortalama(Ogrenci, Ders, Ort),
    Ort >= 50.

kaldi(Ogrenci, Ders) :-
    ortalama(Ogrenci, Ders, Ort),
    Ort < 50.

ust_dersi_alabilir(Ogrenci, YeniDers) :-
    onkosul(YeniDers, EskiDers),
    gecti(Ogrenci, EskiDers).

% --- HARF NOTU SİSTEMİ ---
harf_notu(Ort, 'AA') :- Ort >= 90, Ort =< 100.
harf_notu(Ort, 'BA') :- Ort >= 85, Ort < 90.
harf_notu(Ort, 'BB') :- Ort >= 80, Ort < 85.
harf_notu(Ort, 'CB') :- Ort >= 75, Ort < 80.
harf_notu(Ort, 'CC') :- Ort >= 65, Ort < 75.
harf_notu(Ort, 'DC') :- Ort >= 60, Ort < 65.
harf_notu(Ort, 'DD') :- Ort >= 50, Ort < 60.
harf_notu(Ort, 'FF') :- Ort < 50.

% --- TRANSKRİPT YAZDIRICI ---
transkript(Ogrenci) :-
    write('======================================'), nl,
    write('OGRENCI TRANSKRIPTI'), nl,
    write('Isim: '), write(Ogrenci), nl,
    write('======================================'), nl,
    ortalama(Ogrenci, Ders, Ort),
    harf_notu(Ort, Harf),
    write('- '), write(Ders), write(' | Ort: '), write(Ort), write(' -> ['), write(Harf), write(']'), nl,
    fail.

transkript(_).

% --- İNTERAKTİF GİRDİ VE HAFIZA ---
yeni_not_hesapla :-
    write('Ogrencinin adi nedir? (Kucuk harfle ve sonuna nokta koyarak): '), read(Ogrenci),
    write('Dersin adi nedir? '), read(Ders),
    write('Vize notunu girin: '), read(Vize),
    write('Final notunu girin: '), read(Final),
    Ort is (Vize * 0.4) + (Final * 0.6),
    harf_notu(Ort, Harf), 
    write(Ogrenci), write(' isimli ogrencinin ortalamasi: '), write(Ort), write(' - Harf Notu: '), write(Harf), nl,
    assertz(not_bilgisi(Ogrenci, Ders, Vize, Final)),
    dosyaya_kaydet(Ogrenci, Ders, Vize, Final, Ort, Harf),
    write('Sistem: Notlar basariyla hafizaya ve log dosyasina eklendi!').

% --- DOSYAYA KAYDETME ---
dosyaya_kaydet(Ogrenci, Ders, Vize, Final, Ort, Harf) :-
    open('notlar.txt', append, Dosya),
    write(Dosya, Ogrenci), 
    write(Dosya, ' - Ders: '), write(Dosya, Ders), 
    write(Dosya, ' | Vize: '), write(Dosya, Vize), 
    write(Dosya, ' Final: '), write(Dosya, Final), 
    write(Dosya, ' | Ort: '), write(Dosya, Ort), 
    write(Dosya, ' -> ['), write(Dosya, Harf), write(Dosya, ']'), nl(Dosya),
    close(Dosya).





/*

1. Öğrencinin tüm derslerini ve harf notlarını içeren transkripti basma:
?- transkript(gokcen).

2. Belirli bir dersin vize ve final ağırlıklı ortalamasını hesaplatma:
?- ortalama(gokcen, matematik1, Ort).

3. Bir öğrencinin o dersten geçip geçmediğini sorgulama:
?- gecti(omer, programlama1).

4. Bir öğrencinin o dersten kalıp kalmadığını sorgulama:
?- kaldi(gokcen, programlama1).

5. Önkoşul kuralına göre bir üst dersin alınıp alınamayacağını test etme:
?- ust_dersi_alabilir(gokcen, matematik2).

6. (İNTERAKTİF) Klavyeden dinamik not girme ve hafızaya kaydetme fonksiyonu:
?- yeni_not_hesapla.
(Not: Bilgileri girerken sonlarına mutlaka NOKTA (.) koyup Entera basın)

7. Girilen notları 'notlar.txt' dosyasına kaydetme:
?- dosyaya_kaydet(gokcen, 40, 50).
(Not: Bu komutu çalıştırdıktan sonra projenizin ana klasöründe 'notlar.txt' dosyasını açarak kaydedildiğinden emin olabilirsiniz)



*/
