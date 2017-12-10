program logik; {Joel Jancarik 2012/2013 Zapoctovy program Programovani I NMIN101}
{program, ktery hraje hru logik. Hra obsahuje n barev a k policek. Na zacatku se zaplni policka barvami. Pote se hada, jake barvy
na kterych polickach jsou. Pokud je na policku spravna barva dostava se bily puntik, pokud je spravna barva, ale na jinem policku
dostava se cerny puntik}
const   n=8; {pocet barev}
        k=5; {pocet policek}
        max=20;  {maximalni pocet otazek}
        omezeni=100; {pouziva se v treti fazi, cim vyssi omezeni, tim vyssi presnost, ale i pametova narocnost, pro maximalni
        staci trochu pod k!}
type zapis=array [1..k] of 1..n;  {v tomto formatu se ukladaji vstupy}
tabulka = array [1..n] of 0..k;   {Nekdy je vyhodnejsi pamatovat si pouze, ktere barvy se pouzily a kolikrat}
boliny=array [1..k] of boolean;   {napriklad na pamatovani si jiz pouzitych}
var pole: zapis; {sem se uklada spravny vysledek, toto pole se pouziva jen pri kontrole}
{globalni promenne}
vysledky: array [1..max] of integer;  {ukladaji se sem vysledky ve tveru (k+1) nasobek za bilou, obycejne za cernou}
vyzkouseno: array [1..max] of zapis;  {zde se ukladaji zkontrolovane vstupy}
d:integer;                {d je pocet jiz zkontrolovanych vstupu}
f,g:text;
{konec globalnich promennych}

function kontrola (tip:zapis): integer; {vraci k+1 krat za spravne misto }
        var vysledek,i,j:integer;
                kopie: array [1..k] of boolean;
                koptip: array [1..k] of boolean;
        begin
        vysledek:=0;
        for i:=1 to k do
        begin
                kopie[i]:=true; //inicializace kopii
                koptip[i]:=true;
        end;
        for i:=1 to k do   {vyhledava spravne barvy na spravnem miste}
        begin
                if tip[i]=pole[i] then
                begin
                        vysledek:=vysledek+k+1;
                        koptip [i]:=false;
                        kopie [i]:=false;
                end;
        end;
        for i:=1 to k do   {vyhledava spravne barvy na spatnych mistech}
        begin
                for j:=1 to k do
                begin
                        if (pole[j]=tip[i]) and (koptip [i]) and (kopie [j]) then {druha podminka zabranuje pocitani jednoho typu vicekrat }
                        begin
                                koptip[i]:=false;
                                kopie[j]:=false;
                                vysledek:=vysledek+1;
                        end;
                end;
        end;
        kontrola:=vysledek;
        end;
procedure inicializuj (); {vytvori nahodny vstup}
var i:integer;
begin
        {randomize();}
        for i:=1 to k do
        begin
                pole [i]:=random (n)+1;
        end;
        {pro kontrolu se zde daji vstupy vytvorit i rucne}
        {pole[1]:=8;
        pole[2]:=10;
        pole[3]:=3;
        pole[4]:=5;
        pole[5]:=7;
        pole[6]:=6;
        pole[7]:=8;
        pole[8]:=1;
        pole[9]:=6;
        pole[10]:=3;}
end;

function tah ():integer;  {predstavuje hracuv tah}
        var     i,v:integer;
                tip:zapis;
        begin
        for i:=1 to k do
                read (tip[i]);
        v:=kontrola(tip);
        writeln (v div (k+1),'/',v mod (k+1));
        writeln ('');
        tah:=v;
        end;
{nasledujici slouzi k hrani hrace}
{var i:integer;
begin
inicializuj ();
// for i:=1 to k do write (pole [i]); //vypise na vystup vysledek
for i:=1 to 10 do tah();
for i:=1 to k do write (pole [i]); //vypise na vystup vysledek
end.}

function prvnifaze ():tabulka;    {v prvni fazi se ptam na vsechny barvy, navraci pocet opakovani jednotlivych barev}
var i,j,l,v1,v2,v,prebyvajici,posledni,opakovano:integer;
zkouska:zapis;
pouzito:tabulka; {zde se uklada vysledek, ktery se pote vraci}
begin
for i:=1 to n do pouzito[i]:=1;
v1:=0;
v2:=0;
d:=n div k;
if n mod k <> 0 then d:=d+1;
prebyvajici:=(d*k) mod n;  {k-(n mod k)} {pocita kolikrat je potreba nejakou barvu zdvojit}
posledni:=0;
for i:=1 to d do
begin
        if v1+v2<k then
        begin
                if (prebyvajici >0) then
                begin
                        opakovano:=0;
                        for j:=1 to k-(prebyvajici div (d-i+1)) do
                        begin
                                zkouska [j]:=posledni+j;
                        end;
                        posledni:=posledni+j;
                        for j:=k-(prebyvajici div (d-i+1))+1 to k do  {zde se zdvojuji barvy}
                        begin
                                zkouska [j]:=posledni-j+k-(prebyvajici div (d-i+1))+1;
                                opakovano:=opakovano+1;
                                inc (pouzito [posledni-j+k-(prebyvajici div (d-i+1))+1]);
                        end;
                        prebyvajici:=prebyvajici-opakovano;
                end
                else
                begin
                        for j:=1 to k do zkouska [j]:=posledni+j;
                        posledni:=posledni+k;
                end;
        end
        else d:=i-1;
        v:=kontrola (zkouska); {vysledek se rovnou kontroluje a uklada}
        v1:=v1+ v div (k+1);
        v2:=v2+ v mod (k+1);
        vysledky [i]:=v;
        vyzkouseno[i]:=zkouska;
end;
prvnifaze:=pouzito;
end;

{promenne pro druhou fazi}
var rekzapis:zapis; {zde se uklada pokus, ktery by mohl byt spravne}
konecrekurze:boolean; {v pripade, ze se pokus ansel, rekurze konci}
{V druhe fazi se pouzivaji tri procedury: druhafaze, rekurze, vyber. Druhou fazi se zacina a ta v cyklu pousti rekurzi,
dokud nejsou nalezeny presne vsechny barvy. REKURZE spolecne s VYBER hleda mozne reseni, ktere i vyzkousi. REKURZE hleda
rekurzivne po vysledcich od D do 0, VYBER zkousi postupne vsechny moznosti vyplneni otazky}

procedure rekurze (hladina,mam:integer;t:tabulka); forward;   {rekurzivni procedury se volaji navzajem}

procedure vyber (kolik,odkaz,patro,mam,delkarekzapisu:integer; tab:tabulka; nesmim:boliny);
{KOLIK je pocet barev, ktere je potreba vybrat. ODKAZ je cislo vysledku, s kterymi se prave pracuje
PATRO je policko od 1 do k, ktere se prave vyplnuje, MAM je pocet jiz nalezenych,
TAB je tabulka, kam se uklada kolik kterych prvku se smi jeste pouzit, NESMIM vyplnuje rekurze a jsou to policka,
za ktera se jiz zapocitaly body a tedy je nelze vynechat ani pocitat}
var j:integer;
begin
        if patro<=k then
        begin
        if ((tab [vyzkouseno[odkaz][patro]])>0) and (mam<kolik) and (not nesmim [patro]) then
        {pokud jsou tyto podminky splnene, tak se dane policko ze zapisu pouzije}
                begin
                rekzapis [delkarekzapisu+mam+1]:=vyzkouseno[odkaz][patro];
                tab[vyzkouseno[odkaz][patro]]:=tab[vyzkouseno[odkaz][patro]]-1;
                if not konecrekurze then vyber (kolik,odkaz,patro+1,mam+1,delkarekzapisu,tab,nesmim);
                end;
        if not nesmim[patro] then tab[vyzkouseno[odkaz][patro]]:=0;
        if not konecrekurze then vyber (kolik,odkaz,patro+1,mam,delkarekzapisu,tab,nesmim); {zde se pokracuje bez pouziti tohoto policka}
        end
        else  {konec rekurze ve VYBER, posila je na dalsi patro REKURZE}
        if (mam=kolik) and not konecrekurze then rekurze (odkaz-1,mam+delkarekzapisu,tab);
end;

var hotovo:boolean;
procedure rekurze (hladina,mam:integer;t:tabulka);
var j,i,l,v:integer;
pouzito,pevne: boliny;
nenalezen:boolean;
begin

        if hladina>0 then
        begin
        for i:=1 to mam do pouzito [i]:=false;
        for i:=1 to k do pevne[i]:=false;
        v:=vysledky[hladina] mod (k+1) + vysledky [hladina] div (k+1);
        for j:=1 to mam do     {vyplnuje pevne/nesmim pro VYBER}
        begin
                for i:=1 to k do
                begin
                        if (rekzapis [j]=vyzkouseno [hladina][i]) and not pouzito[j] and not pevne[i] then
                        begin
                        v:=v-1;
                        pouzito [j]:=true;
                        pevne [i]:=true;
                        end;
                end;
        end;
        if (v>=0) and (mam+v<=k) then vyber (v,hladina,1,0,mam,t,pevne);

        end
        else  {V pripade konce}
        begin
                nenalezen:=false;
                for j:=mam+1 to k do  {zajistuje pripadne doplneni REKZAZNAMU do delky K}
                begin
                        i:=1;
                        nenalezen:=true;
                        while (i<=n) and nenalezen do
                        begin
                                if t [i]>0 then
                                begin
                                        t [i]:=t [i]-1;
                                        rekzapis[j]:=i;
                                        nenalezen:=false;
                                end;
                                i:=i+1;
                        end;
                end;
                if not nenalezen then  {nalezeny vysledek}
                begin
                        vysledky[d+1]:=kontrola (rekzapis);
                        vyzkouseno [d+1]:=rekzapis;
                        konecrekurze:=true;
                end;
        end;

end;

procedure druhafaze (stejnacisla:integer;t:tabulka);
var i,j,a:integer;
begin
i:=1;
for j:=1 to d do   {vyplnuje tabulku t, tak aby pro barvu i bylo na i/tem miste pocet jejich moznych pouziti}
begin
        a:=0;
        while a<k do
                begin
                a:=a+t [i];
                if t[i]>(vysledky [j] div (k+1) + vysledky [j] mod (k+1)) then t[i]:=vysledky [j] div (k+1) + vysledky [j] mod (k+1)
                else t[i]:=t[i]+stejnacisla;
                i:=i+1;
                end;

end;
while vysledky [d] mod (k+1) + vysledky [d] div (k+1) <> k do {Dokud nemam presne barvy}
        begin
        konecrekurze:=false;
        rekurze (d,0,t);
        d:=d+1;
        end;
end;

{promenne pro treti fazi}
var t:tabulka; {zde jsou ulozene presne pocty pouzitych barev}
z:zapis; {zde se uklada mozny vstup, ktery se pote kontroluje}
pocet:integer; {toto je pocet moznych vysledku}
tip:array [1..omezeni] of zapis; {zde se ukladaji mozne vysledky}

procedure vyzkousej ();   {kontroluje spravnost vstupu}
var i,j,v:integer;
spravne:boolean;
begin
        i:=d;
        spravne:=true;
        while (i>0) and spravne do
        begin
                v:=0;
                for j:=1 to k do
                begin
                        if vyzkouseno [i][j]=z[j] then v:=v+1;
                end;
                spravne:=vysledky[i] div (k+1)=v;
                i:=i-1;
        end;
        if spravne then
        begin
                pocet:=pocet+1;
                tip[pocet]:=z;
        end;
end;




procedure generuj (pozice:integer);   {generuje vsechny mozne vstupy}
var i:integer;
begin
if pocet<omezeni then
        begin
        if pozice<=k then
                begin
                for i:=1 to n do
                        begin
                                if t[i]>0 then
                                begin
                                z[pozice]:=i;
                                t[i]:=t[i]-1;
                                generuj (pozice+1);
                                t[i]:=t[i]+1;
                                end;
                        end;
                end
        else
        vyzkousej ();
end;
end;
function spocti ():integer;  {pracuje s moznymi vstupy z tip, ukolem je nalezt takovy, ktery v nejhorsim pripade nejvice ostatnich
vyradi. Algoritmus je takovy, ze se spocita pocet spolecnych barev na pozicich s ostatnimi. Podle tohoto poctu se spoji do
skupin. Pote se nalezne maximumu M z velikosti techto skupin. Nejmensi ze vsech maxim je MAX a to je to co hledame}
var i,j,l,max,m,misto:integer;
v:array [1..omezeni] of 0..k;
skupiny:array [0..k] of 0..omezeni;
begin
        max:=pocet;
        for i:=1 to pocet do
                begin
                        for j:=1 to pocet do v[j]:=0;
                        for j:=0 to k do skupiny[j]:=0;
                        for j:=1 to pocet do  {pocita pocet spolecnych pozic}
                        begin
                                for l:=1 to k do
                                begin
                                if tip[i][l]=tip[j][l] then v[j]:=v[j]+1;
                                end;
                        end;
                        for j:=1 to pocet do {podle spolecnych pozic do skupin}
                        begin
                                skupiny[v[j]]:=skupiny[v[j]]+1;
                        end;
                        m:=0;
                        for j:=0 to k do  {pocita maximalni velikost ve skupine}
                        begin
                                if m<skupiny[j] then
                                begin
                                m:=skupiny[j];
                                end;
                        end;
                        if m<max then {uklada minimalni z maximalnich velikosti ve skupine}
                        begin
                                max:=m;
                                misto:=i;
                        end;

                end;
        spocti:=misto; {vraci pozici nejvhodnejsiho vysledku}
end;


procedure tretifaze (stejnacisla:integer);
var i,j,a,v,p:integer;
zustal:array [1..omezeni] of boolean;
begin
        for i:=1 to n do t [i]:=0;
        for i:=1 to k do
        begin    {vyplnuje tabulku}
        t [vyzkouseno[d][i]]:=t [vyzkouseno[d][i]]+1;
        end;
        pocet:=0;
        generuj (1);
        while pocet>1 do  {dokud je vice moznych vysledku}
        begin
                a:=spocti();
                d:=d+1;
                vysledky [d]:=kontrola (tip[a]);
                vyzkouseno[d]:=tip[a];        {vyzkousej nejlepsi z nich dle spocti}
                if pocet=omezeni then  {pokud bylo omezeni musi se znovu generovat}
                begin
                        pocet:=0;
                        generuj (1);
                end
                else   {jinak staci vyradit spatne}
                begin
                for i:=1 to pocet do zustal[i]:=false;
                for i:=1 to pocet do    {oznacuji se spatne}
                begin
                        v:=0;
                        for j:=1 to k do
                        begin
                                if vyzkouseno[d][j]=tip[i][j] then v:=v+1;
                        end;
                        zustal[i]:=vysledky[d] div (k+1)=v;
                end;
                p:=0;
                for i:=1 to pocet do  {preskupuji se spatne}
                begin
                        if zustal[i] then
                                begin
                                p:=p+1;
                                tip[p]:=tip[i];
                        end;
                end;
                pocet:=p;
                end;
        end;
        if vysledky [d]<>k*(k+1) then {pokud se vysledek neulozil musi se jeste ulozit}
        begin
                vysledky [d]:=kontrola (tip[1]);
                vyzkouseno[d]:=tip[1];
        end;
end;
procedure vypis (obrazovka:boolean);
var i,j:integer;
begin
        if obrazovka then
        begin
        for i:=1 to d do
        begin
                for j:=1 to k do write (vyzkouseno [i][j],' ');
                writeln (vysledky[i] div (k+1),'/',vysledky[i] mod (k+1));
        end;
        end
        else
        begin
                for i:=1 to d do
                begin
                for j:=1 to k do write (g,vyzkouseno [i][j],' ');
                writeln (g,vysledky[i] div (k+1),'/',vysledky[i] mod (k+1));
                end;
        end;
end;

var i,j,v,c:integer;
a:char;
begin {telo hlavniho programu}
assign (f,'vstup.txt');
assign (g,'vystup.txt');
writeln ('Chci: A-hrat, B-vyzkouset vstup, C-vyplnit soubor se vstupy, D-vyzkouset vstupy ze souboru, E-ukoncit');
readln (a);
while not ( (( ord(a)>=ord ('a')) and (ord (a)<=ord('e')) or ((ord (a)>=ord ('A')) and (ord (a)<=ord('E'))) )) do readln (a);
writeln();
if (a='a') or (a='A') then
begin
        writeln ('kolik tahu?');
        c:=0;
        read (a);
        while (ord (a)>=ord ('0')) and (ord (a)<=ord('9')) and (c<max) do
        begin
                c:=10*c+ord(a)-ord ('0');
                read (a);
        end;
        if c>=max then
        begin
        c:=max;
        writeln ('maximalni pocet tahu je: ',max);
        end;
        writeln ('cisla 1..',n,' odelene mezerami, pocet cisel je ',k);
        randomize();
        inicializuj ();
        i:=1;
        v:=0;
        while (i<=c) and (v<>(k+1)*k) do
                begin
                v:= tah ();
                inc (i);
                end;
        if v=(k+1)*k then writeln ('spravne')
        else
        begin
                write ('spravny vysledek je: ');
                for i:=1 to k do write (pole[i],' ');
        end;
end;
if (a='b') or (a='B') then
begin
        writeln ('zadejte vstup ve formatu cislo(mezera)cislo...');
        for i:=1 to k do
        begin
        read (pole[i]);
        end;
        t:=prvnifaze();
        v:=0;
        for i:=1 to d do v:=v+ (vysledky[i] mod (k+1)) + (vysledky [i] div (k+1)); {pocita pocet barev, ktere jsme nevideli}
        druhafaze (k-v,t);
        tretifaze (k-v);
        vypis (true);
end;
if (a='c') or (a='C') then
begin
        rewrite (f);
        writeln ('zadejte pocet cisel, ktere se maji vygenerovat:');
        readln (c);
        randomize();
        for j:=1 to c do
        begin
                inicializuj ();
                for i:=1 to k do write (f,pole[i],' ');
                writeln (f);
        end;
        writeln ('cisla jsou vygenerovana');
        close (f);
end;
if (a='d') or (a='D') then
begin
        reset (f);
        rewrite (g);
        writeln ('Co ma program vypsat? A-pouze pocet kroku, B-postup');
        readln (a);
        while not ((ord (a)>=ord ('a')) and (ord (a)<=ord('b')) or (ord (a)>=ord ('A')) and (ord (a)<=ord('B'))) do read (a);
        while not EOF (f) do
        begin
                for i:=1 to k do read (f,pole[i]);
                readln(f);
                t:=prvnifaze();
                v:=0;
                for i:=1 to d do v:=v+ (vysledky[i] mod (k+1)) + (vysledky [i] div (k+1)); {pocita pocet barev, ktere jsme nevideli}
                druhafaze (k-v,t);
                tretifaze (k-v);
                if (a='a') or (a='A') then writeln (g,d)
                else vypis (false);
                writeln (g);
        end;
        close (f);
        close (g);
end;
end.


















