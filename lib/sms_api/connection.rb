require 'net/http'
require 'uri'

module SmsApi
  class Connection
    # Available options to pass in constructor
    # This options you can use to send in params
    AVAILABLE_OPTIONS = [:password, :username, :from, :to, :group, :message, :from, :encoding, :flash, :test,
                         :details, :date, :datacodin, :idx, :check_idx, :single, :eco, :nounicode, :fast]

    # Required field for sending sms
    REQUIRED_FIELDS = [:password, :username, :to, :message]

    attr_accessor *AVAILABLE_OPTIONS, :passed_options

    #=================================================================================================
    # Parametr      | Opis
    #=================================================================================================
    # username      | Nazwa użytkownika lub główny adres e-mail przypisany do konta w serwisie SMSAPI
    #-------------------------------------------------------------------------------------------------
    # password      | Hasło do Twojego konta w serwisie SMSAPI
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
    # Uwaga! Parametry group oraz to są zamienne, w odwołaniu musi się pojawić jeden z tych dwóch
    # parametrów. Brak jednego z tych dwóch parametrów lub wystąpienie ich obu spowoduje niewysłanie
    # wiadomości oraz zwrócenie błędu ERROR: 13.
    #=================================================================================================
    # Default constructor. Received arguments should be as a hash.
    def initialize(*args)
      options = args.extract_options!.symbolize_keys!
      options.merge!(username: (options[:username] || SmsApi.username),
                     password: (options[:password] || SmsApi.password),
                     test: SmsApi.test_mode)

      options.each_pair do |opt_key, opt_val|
        if AVAILABLE_OPTIONS.include?(opt_key)
          self.send("#{opt_key}=", opt_val)
        else
          raise ArgumentError, "There is no option: #{opt_key}. Please check documentation."
        end
      end

      # Encode password and save in instance variable
      self.password = Digest::MD5.hexdigest(options[:password])

      # We are saving information about which options were passed
      self.passed_options = options.keys

      self
    end

    #=================================================================================================
    # Request: http://api.smsapi.pl/sms.do?username=uzytkownik&password=hasloMD5&from=nazwa&to=48500500500&message=test wiadomosci
    # Respons: OK:<ID>:<POINTS> or if error ERROR:<ERR><ID><POINTS>
    #=================================================================================================
    # Sends a sms and raise an error if something goes wrong
    def deliver!
      # Check if sms have all require fields
      validate_sms

      # Check if phone number is correct
      validate_phone_numbers!

      # Sending sms to smsapi.pl
      response = Net::HTTP.post_form(URI.parse(SmsApi.api_url), generate_params).body

      # Checking response. If is an error then we are raising exception
      # other wise we return array [:ID, :POINTS]
      # where ID is an sms ID and POINTS is cost of an sms
      if response.match(/^ERROR:(\d+)$/)
        raise DeliverError, $1
      elsif response.match(/^OK:(.+):(.+)$/)
        [$1, $2]
      else
        raise DeliverError, "Unknow response."
      end
    end

    # Sends a sms and return false if something goes wrong
    def deliver
      begin
        deliver!
        true
      rescue DeliverError, InvalidPhoneNumberNumeraticly, InvalidPhoneNumberLength,
             InvalidPhoneNumber, InvalidSmsPropertis => e
        false
      end
    end

    private
    # Validate presence of required fields
    def validate_sms
      REQUIRED_FIELDS.each do |field|
        if self.send(field) == nil || self.send(field) == ""
          raise InvalidSmsPropertis, "Option #{field} is unset. This field is required."
        end
      end
      true
    end

    def validate_phone_number(number)
      phone_number      = number.gsub(/\s|\-|\+|\.|\(|\)/, '')
      if !(4..20).include?(phone_number.length)
        raise InvalidPhoneNumberLength, "Please check phone number: #{@to}."
      elsif phone_number.match(/[A-Za-z]/)
        raise InvalidPhoneNumberNumeraticly, "Phone number contains letters: #{@to}."
      end
      phone_number
    end

    def validate_phone_numbers!
      phone_numbers = to
      phone_numbers = [phone_numbers] if phone_numbers.class == String
      self.to = phone_numbers.map { |num| validate_phone_number(num) }.join(',')
      true
    end

    # Return hash of options which was set.
    def generate_params
      result = {}

      passed_options.each do |opt|
        result[opt] = self.send(opt)
      end

      # Setting up test option
      self.test ? result[:test] = 1 : result.delete(:test)

      result
    end
  end
end

class InvalidPhoneNumberNumeraticly < StandardError; end;
class InvalidPhoneNumberLength < StandardError; end;
class InvalidPhoneNumber < StandardError; end;
class InvalidSmsPropertis < StandardError; end;
class DeliverError < StandardError
  def initialize(status)
    super(SmsApi::Mappings::ERRORS.keys.include?(status.to_i) ? SmsApi::Mappings::ERRORS[status.to_i] : status)
  end
end
