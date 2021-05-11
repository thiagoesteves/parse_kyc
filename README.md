![github workflow](https://github.com/thiagoesteves/parse_kyc/workflows/Elixir%20CI/badge.svg)
[![Erlang/OTP Release](https://img.shields.io/badge/Erlang-OTP--22.0-green.svg)](https://github.com/erlang/otp/releases/tag/OTP-22.0)

# Parse KYC (Know Your Costumer)

## How to generate the script

```
mix escript.build
```

## How it works

This script is going to parse an html page from KYC. In order to collect the html, visit https://edoc.identitymind.com/reference#kyc-1 and click in the target command. After, press F12 to inspect the element in Google Chrome, copy the body and paste in a file (e. g. test.txt). Once you have the html saved, inspect the command you want to parse. To do it, click in the command (https://edoc.identitymind.com/reference#create-1) and inspect the first element of "Body Params", e.g., man : It belongs to **fieldset id=body-create**, the target "id" is: body-create

```
./bin/parse_kyc --id "body-create" --filename "test.txt"
```


