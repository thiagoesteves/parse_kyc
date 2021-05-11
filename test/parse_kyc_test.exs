defmodule ParseKycTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO
  import Parse.Kyc, only: [main: 1]

  test "--help call for help" do
    fun = fn -> main(["--help"]) end

    expected =
      "synopsis:\n  This script is going to parse an html page from KYC. In order to collect the html, visit\n  https://edoc.identitymind.com/reference#kyc-1 and click in the target command. After,\n  press F12 to inspect the element in Google Chrome, copy the body and paste in a file\n  (e. g. test.txt).\n\n  Once you have the html saved, inspect the command you want to parse. To do it,\n  click in the command (https://edoc.identitymind.com/reference#create-1) and\n  inspect the first element of \"Body Params\", e.g., man :\n  It belongs to <fieldset id=body-create>, the target \"id\" is: body-create\n\nusage:\n  ./bin/parse_kyc --id \"body-create\" --filename \"test.txt\"\noptions:\n  --filename File with the html contents\n  --id       fieldset that will be parsed\n\n"

    actual = capture_io(:stdio, fun)
    assert actual == expected
  end

  test "parse body-transactionFeedback" do
    fun = fn -> main(["--filename", "test/test.txt", "--id", "body-transactionFeedback"]) end

    expected =
      "Parsing the file test/test.txt for the id: body-transactionFeedback\n@body-transactionFeedback %{amt: %{description: \"The amount of the transaction\", value: \"\"}, auth_code: %{description: \"Authorization code returned by the gateway\", value: \"\"}, auth_response: %{description: \"The result of the Auth/Sale to the gateway\", value: \"\"}, auth_response_text: %{description: \"Auth comments from the Gateway\", value: \"\"}, avs_result: %{description: \"The AVS result from the gateway\", value: \"\"}, bank_status: %{description: \"The current status of the transaction at the gateway/bank.  Default is \\\"u\\\", undefined\", value: \"\"}, ccy: %{description: \"The ISO 4217 currency code of the transaction encoded as a String. Default is USD.  Additional Cryptocurrencies are supported, please contact support@identitymind.com\", value: \"\"}, cnv_rate: %{description: \"Conversion rate between the provided currency and the United States Dollar.\", value: \"\"}, cvv2_result: %{description: \"The CVV2 result from the gateway\", value: \"\"}, details: %{description: \"The details of the transaction\", value: \"\"}, error_code: %{description: \"The error code if any from the gateway.  Values are dependent on the \\\"gateway\\\" used\", value: \"\"}, gateway: %{description: \"The name of the payment Gateway used. This information is used to interpret the result/error codes\", value: \"\"}, impactBeneficiary: %{description: \"If the underlying transaction is a transfer, should the feedback be associated with the beneficiary / destination?   Default is false\", value: \"false\"}, impactOriginator: %{description: \"If the underlying transaction is a transfer, should the feedback be associated with the originator / source?   Default is true\", value: \"false\"}, m: %{description: \"Internal Use Only.  The api name of the merchant to whom this feedback is to be applied.\", value: \"\"}, reason: %{description: \"Free-form descriptive text providing additional information about the feedback\", value: \"\"}, reportTS: %{description: \"The timestamp of the feedback\", value: \"0\"}, tags: %{description: \"Tags\", value: []}, tid: %{description: \"The transaction ID. If the tid is provided with a new/different value in a feedback call, this value will overwrite the old transaction ID. The new transaction ID will then be used to reference the transaction, and the old ID will be invalid. Maximum length is 40 characters\", value: \"\"}, username: %{description: \"The name of the analyst who provides the feedback\", value: \"\"}}\n"

    actual = capture_io(:stdio, fun)
    assert actual == expected
  end
end
