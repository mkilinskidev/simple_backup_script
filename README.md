# Skrypt do tworzenia kopii zapasowych na hostingu
## 1. Informacje o skrypcie
Starałem się, aby skrypt był bardzo prosty, ale jednak w minimalnym stopniu zarządzalny. Lista stron do backupu wraz z odpowiadającymi im bazami znajduje się w katalogu backup/websites.txt. Ja swoje strony internetowe trzymam w katalogu websites, więc struktura tego pliku jest nastepująca:

``` 
nazwa_strony_w_katalogu_websites:nazwa_bazy_danych
```

Backup bazy danych jest wykonywany klasycznym mysqldump, podając w parametrze ścieżkę do pliku z konfiguracją mysql. Ja utworzyłem sobie jednego serwisowego użytkownika i tym użytkownikiem robię dump bazy danych. Struktura pliku `.my.cnf` jest następująca:

```
[mysqldump]
user=twojuser
password=twojehaslo
host=hostmysql
```

## 2. Niezbędne narzędzia
Do wysyłki spakowanego backupu używam narzędzia o nazwie `rclone`. Jest to darmowe narzędzie, bardzo podobne do natywnego `rsync`, dającego możliwość konfiguracji wielu miejsc zdalnych. Szczegóły projektu znajdziecie pod adresem https://rclone.org. 

### 2.1 Instalacja rclone
 Z uwagi na brak administartora na serwerze, instalacja odbywa się poprzez ściągnięcie i rozpakowanie pliku zip ze strony https://rclone.org/downloads/ do katalogu domowego. Ja binarkę rclone trzymam w katalogu `/home/klient.dhosting.pl/USER/rclone/`. Poleceniem `/home/klient.dhosting.pl/USER/rclone/rclone config` dokonujecie konfiguracji miejsca docelowego. Polecam zapoznać się z informacjami na tej stronie https://rclone.org/docs/. 

 ### 2.2 Użycie rclone
 Po poprawnej konfiguracji warto ją przetestować:

 `/home/klient.dhosting.pl/USER/rclone/rclone lsd foo:/` listuje katalogi w udziale foo, jakikowiek on by nie był (ftp, sftp, google drive itd)

 `/home/klient.dhosting.pl/USER/rclone/rclone ls foo:/` listuje pliki w udziale foo

 `/home/klient.dhosting.pl/USER/rclone/rclone copy /foo/bar destination:/some/folder -P` oznacza skopiowanie wszystkich plików z katalogu `/foo/bar` do zdalnego katalogu `/some/folder`. Przełącznik -P to progress bar.

 ## 3. Użycie skryptu
 * W repozytorium zachowałem moją oryginalną strukturę katalogów, na której pracuje skrypt. Powinieneś zmodyfikować skrypt, jeśli Twoja struktura jest/będzie inna. Strony internetowe prawdopodobnie trzymasz w inny sposób niż ja, więc zmodyfikuj skrypt.

 * W skrypcie każde odniesienie do mojego użytkownika zamieniłem na słowo USER - wpisz w to miejce swojego użytkownika

* W skrypcie, w miejscu użycia rclone wpisz swoje własne miejsce docelowe.

* W pliku `.my.cfg` wpisz własne dane użytkownika mysql

* W pliku `backup/websites.txt` wpisz listę stron wraz z nazwami baz danych, które mają podlegać backupowi