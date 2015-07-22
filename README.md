NRSGATEWAY SMS
==============

Provides a gateway to use NRSGateway SMS service over HTTP

Usage
-----

    NrsGateway.send_sms(:login => "login",
                        :password => "password", 
                        :destination => "34.." || ["34...","34..."],
                        :message => "Message with 159 chars maximum")

- __Login__: supplied by NRSGateway.
- __Password__: supplied by NRSGateway.
- __Destination__: destination numbers, international format without (+). If an Array is passed, SMS will be sent to all numbers.
- __Message__: Message to send, maximum 160 characters. Must be codified at UTF8.

Response are a Hash with :code, :description and :id with send number if request was OK. 

Response codes are:

- __0__: Accepted for delivery
- __101__: Internal Database error
- __102__: No valid recipients
- __103__: Username or password unknown
- __104__: Text message missing
- __105__: Text message too long
- __106__: Sender missing
- __107__: Sender too long
- __108__: No valid Datetime for send
- __109__: Notification URL incorrect
- __110__: Exceeded maximum parts allowed or incorrect number of parts
- __111__: Not enough credits

More information
----------------

http://nrsgateway.com/http_api_peticion.php

- Copyright (c) 2015 Angel García Pérez
