[![Code Climate](https://codeclimate.com/github/petergebala/sms_api.png)](https://codeclimate.com/github/petergebala/sms_api)
# SmsApi

Simple gem responsible for connecting to smsapi.pl and sending simple smses.
Version 0.1 supports only sending sms.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sms_api', :git => 'git://github.com/petergebala/sms_api.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sms_api

Add configuration file to initializers:

```ruby
SmsApi.setup do |config|
  config.username   = "login to smsapi.pl page"
  config.password   = "password to smsapi.pl page"
  config.test_mode  = Rails.env.production? ? false : true
end
```

## Usage

```ruby
sms = SmsApi::Connection.new(:to => "555-555-555", :message => "Lorem Ipsum", :from => "Alert")
sms.deliver! # Then raise an error if failure
# or
sms.deliver # Return false on failure
```
    
## Possible options
    #=================================================================================================
    # Parametr      | Opis
    #=================================================================================================
    # username      | Nazwa użytkownika lub główny adres e-mail przypisany do konta w serwisie SMSAPI
    #-------------------------------------------------------------------------------------------------
    # password      | Hasło do Twojego konta w serwisie SMSAPI zaszyfrowane w MD5
    #-------------------------------------------------------------------------------------------------
    # to            | Numer odbiorcy wiadomości w formacie 48xxxxxxxxx lub xxxxxxxxx. Np. 48505602702
    #               | lub 505602702.
    #-------------------------------------------------------------------------------------------------
    # group         | Nazwa grupy kontaktów z książki telefonicznej, do których ma zostać wysłana
    #               | wiadomość
    #-------------------------------------------------------------------------------------------------
    # message       | Treść wiadomości. Standardowo do 160 znaków lub 70 znaków w przypadku
    #               | wystąpienia chociaż jednego znaku specjalnego (polskie znaki uważane są za
    #               | specjalne). Maksymalna długość wiadomości wynosi 459 znaków (lub 201 ze znakami
    #               | specjalnymi) i jest wysłana jako 3 połączone SMS-y, obciążając konto zgodnie z
    #               | aktualnym cennikiem.
    #-------------------------------------------------------------------------------------------------
    # from          | Nazwa nadawcy wiadomości. Pozostawienie pola pustego powoduje wysłanie
    #               | wiadomości od „SMSAPI”. Przyjmowane są tylko nazwy zweryfikowane.
    #               | (&from=aktywna_nazwa). Pole nadawcy należy dodać po zalogowaniu na stronie
    #               | SMSAPI, w zakładce USTAWIENIA → POLA NADAWCY.
    #-------------------------------------------------------------------------------------------------
    # encoding      | Parametr określa kodowanie polskich znaków w SMS-ie. Domyślne kodowanie jest
    #               | windows-1250. Jeżeli występuje konieczność zmiany kodowania, należy użyć parametru
    #               | encoding z danymi:
    #               |   - dla iso-8859-2 (latin2) – należy podać wartość „iso-8859-2”,
    #               |   - dla utf-8 – należy podać wartość „utf-8”.
    #-------------------------------------------------------------------------------------------------
    # flash         | Wysyłanie wiadomości trybem „flash”, odbywa się poprzez podanie parametru flash o
    #               | wartości „1”. SMS-y flash są automatycznie wyświetlane na ekranie głównym telefonu
    #               | komórkowego i nie są przechowywane w skrzynce odbiorczej (jeśli nie zostaną
    #               | zapisane). (&flash=1)
    #-------------------------------------------------------------------------------------------------
    # test          | Wiadomość nie jest wysyłana, wyświetlana jest jedynie odpowiedź (w celach testowych).
    #               | (&test=1)
    #-------------------------------------------------------------------------------------------------
    # details       | W odpowiedzi zawarte jest więcej szczegółów. (Treść wiadomości, długość wiadomość,
    #               | ilość części z jakich składa się wiadomość). (&details=1)
    #-------------------------------------------------------------------------------------------------
    # date          | Data w formacie unix unixtime. Określa kiedy wiadomość ma być wysłana.
    #               | (&date=1287734110). W przypadku wstawienia daty przeszłej wiadomość zostanie
    #               | wysłana od razu.
    #-------------------------------------------------------------------------------------------------
    # datacoding    | Parametr pozwalający na wysyłanie wiadomości WAP PUSH. (&datacoding=bin)
    #-------------------------------------------------------------------------------------------------
    # idx           | Opcjonalny parametr użytkownika wysyłany z wiadomością a następnie zwracany przy
    #               | wywołaniu zwrotnym CALLBACK. (&idx=123)
    #-------------------------------------------------------------------------------------------------
    # check_idx     | Pozwala zabezpieczyć przed wysłanie dwóch wiadomości z identyczną wartością
    #               | parametru idx. W przypadku ustawienia parametru (&check_idx=1) system sprawdza
    #               | czy wiadomość z takim idx już została przyjęta, jeśli tak zwracany jest błąd 53.
    #-------------------------------------------------------------------------------------------------
    # single        | Ustawienie 1 zabezpiecza przed wysłaniem wiadomości składających się z kilku części.
    #               | (ERROR:12)
    #-------------------------------------------------------------------------------------------------
    # eco           | Ustawienie parametru &eco=1 spowoduje wysłanie wiadomości Eco (brak możliwości
    #               | wyboru pola nadawcy, wiadomość wysyłana z losowego numeru dziewięciocyfrowego)
    #               | szczegóły dotyczące wiadomości Eco znajdują się na naszej stronie:
    #               | http://www.smsapi.pl/
    #-------------------------------------------------------------------------------------------------
    # nounicode     | Ustawienie 1 zabezpiecza przed wysłaniem wiadomości ze znakami specjalnymi (w tym
    #               | polskimi) (ERROR:11).
    #-------------------------------------------------------------------------------------------------
    # fast          | Ustawienie 1 spowoduje wysłanie wiadomości przy wykorzystaniu osobnego kanału
    #               | zapewniającego szybkie doręczenie wiadomości Fast. Z parametru korzystać można
    #               | podczas wysyłania wiadomości Pro oraz Eco, Ilość punktów za wysyłkę pomnożona
    #               | będzie przez 1.5
    #=================================================================================================

For more please read [SmsApi.pl](http://smsapi.pl) documentation at [link](http://www.smsapi.pl/sms-api/interfejs-https)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
