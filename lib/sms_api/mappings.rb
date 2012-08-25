# encoding: UTF-8
module SmsApi
  class Mappings
    # Mappings for error codes and their messages
    ERRORS = {
      8  => "Błąd w odwołaniu (Prosimy zgłośić)",
      11 => "Zbyt długa lub brak wiadomości lub ustawiono parametr nounicode i pojawiły się znaki specjalne w wiadomości. Dla wysyłki VMS błąd oznacz brak pliku WAV lub treści TTS.",
      12 => "Wiadomość zawiera ponad 160 znaków (gdy użyty parametr &single=1)",
      13 => "Nieprawidłowy numer odbiorcy",
      14 => "Nieprawidłowe pole nadawcy",
      17 => "Nie można wysłać FLASH ze znakami specjalnymi",
      18 => "Nieprawidłowa liczba parametrów",
      19 => "Za dużo wiadomości w jednym odwołaniu",
      20 => "Nieprawidłowa liczba parametrów IDX",
      21 => "Wiadomość MMS ma za duży rozmiar (maksymalnie 100kB)",
      22 => "Błędny format SMIL",
      23 => "Błąd pobierania pliku dla wiadomości MMS lub VMS",
      24 => "Błędny format pobieranego pliku",
      25 => "Parametry &normalize oraz &datacoding nie mogą być używane jednocześnie.",
      30 => "Brak parametru UDH jak podany jest datacoding=bin",
      31 => "Błąd konwersji TTS",
      32 => "Nie można wysyłać wiadomości Eco, MMS i VMS na zagraniczne numery.",
      33 => "Brak poprawnych numerów",
      40 => "Brak grupy o podanej nazwie",
      41 => "Wybrana grupa jest pusta (brak kontaktów w grupie)",
      50 => "Nie można zaplanować wysyłki na więcej niż 3 miesiące w przyszłość",
      51 => "Ustawiono błędną godzinę wysyłki, wiadomość VMS mogą być wysyłane tylko pomiędzy godzinami 8 a 22",
      52 => "Za dużo prób wysyłki wiadomości do jednego numeru (maksymalnie 10 prób w przeciągu 60sek do jednego numeru)",
      53 => "Nieunikalny parametr idx. Została już przyjęta wiadomość z identyczną wartością parametru idx przy wykorzystaniu parametru &check_idx=1.",
      54 => "Błędny format daty. Ustawiono sprawdzanie poprawności daty &date_validate=1",
      55 => "Brak numerów stacjonarnych w wysyłce i ustawiony parametr skip_gsm",
      101 => "Niepoprawne lub brak danych autoryzacji. UWAGA! Hasło do API może być inne niż hasło do Panelu Klienta",
      102 => "Nieprawidłowy login lub hasło",
      103 => "Brak punków dla tego użytkownika",
      104 => "Brak szablonu",
      105 => "Błędny adres IP (włączony filtr IP dla interfejsu API)",
      200 => "Nieudana próba wysłania wiadomości, prosimy ponowić odwołanie",
      201 => "Wewnętrzny błąd systemu (prosimy zgłosić)",
      202 => "Zbyt duża ilość jednoczesnych odwołań do serwisu, wiadomość nie została wysłana (prosimy odwołać się ponownie)",
      300 => "Nieprawidłowa wartość pola points (przy użyciu pola points jest wymagana wartość 1)",
      301 => "ID wiadomości nie istnieje",
      400 => "Nieprawidłowy ID statusu wiadomości",
      999 => "Wewnętrzny błąd systemu (prosimy zgłosić)"
    }
  end
end
