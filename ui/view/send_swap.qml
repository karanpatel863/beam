import QtQuick 2.11
import QtQuick.Controls 1.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import Beam.Wallet 1.0
import "controls"
import "./utils.js" as Utils

ColumnLayout {
    id: thisView
    property variant parentView: null
    property var    defaultFocusItem: comment_input
    property var    predefinedTxParams: undefined

    function setToken(token) {
        viewModel.token = token
        var currency = viewModel.sendCurrency
        if (currency == Currency.CurrBeam) return;

        var canSwap  = false
        var currname = ""

        if (currency == Currency.CurrBtc) {
            canSwap  = BeamGlobals.haveBtc()
            //% "Bitcoin"
            currname = qsTrId("general-bitcoin")
        }

        if (currency == Currency.CurrLtc){
            canSwap = BeamGlobals.haveLtc()
            //% "Litecoin"
            currname = qsTrId("general-litecoin")
        }

        if (currency == Currency.CurrQtum) {
            canSwap = BeamGlobals.haveQtum()
            //% "QTUM"
            currname = qsTrId("general-qtum")
        }

        if (canSwap) return;

        //% "You do not have %1 connected.\nUpdate your settings and try again."
        swapna.text = qsTrId("swap-currency-na-message").arg(currname).replace("\\n", "\n")
        swapna.open()
    }

    SwapNADialog {
        id:         swapna
        onRejected: parentView.onBadSwap()
        onAccepted: main.openSwapSettings()
    }

    Component.onCompleted: {
        comment_input.forceActiveFocus();
        viewModel.setParameters(predefinedTxParams);
    }

    SendSwapViewModel {
        id: viewModel

        // TODO:SWAP Implement the necessary callbacks and error handling for the send operation
        /*
        onSendMoneyVerified: {
           parent.enabled = true
           walletView.pop()
        }

        onCantSendToExpired: {
            parent.enabled = true;
            Qt.createComponent("send_expired.qml")
                .createObject(sendView)
                .open();
        }
        */
    }

    Timer {
        interval: 1000
        repeat:   true
        running:  true

        onTriggered: {
            const expired = viewModel.expiresTime < (new Date())
            expiresTitle.color = expired ? Style.validator_error : Style.content_main
            expires.color = expired ? Style.validator_error : Style.content_secondary
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        visible: predefinedTxParams == undefined

        SFText {
            font.pixelSize:  14
            font.styleName:  "Bold"; font.weight: Font.Bold
            color:           Style.content_main
            //% "Transaction token"
            text:            qsTrId("send-swap-to-label")
        }

        SFTextInput {
            Layout.fillWidth: true
            id:               tokenInput
            font.pixelSize:   14
            color:            viewModel.tokenValid ? Style.content_main : Style.validator_error
            backgroundColor:  viewModel.tokenValid ? Style.content_main : Style.validator_error
            font.italic :     !viewModel.tokenValid
            text:             viewModel.token
            validator:        RegExpValidator { regExp: /[0-9a-fA-F]{1,}/ }
            selectByMouse:    true
            readOnly:         true
            //% "Please specify contact or transaction token"
            placeholderText:  qsTrId("send-contact-placeholder")
        }

        Item {
            Layout.fillWidth: true
            SFText {
                Layout.alignment: Qt.AlignTop
                id:               receiverTAError
                color:            Style.validator_error
                font.pixelSize:   12
                //% "Invalid address"
                text:             qsTrId("general-invalid-address")
                visible:          !viewModel.tokenValid
            }
        }

        Binding {
            target:   viewModel
            property: "token"
            value:    tokenInput.text
        }
    }

    Grid  {
        Layout.fillWidth: true
        columnSpacing:    70
        columns:          2

        ColumnLayout {
            width: parent.width / 2 - parent.columnSpacing / 2

            //
            // Send Amount
            //
            AmountInput {
                Layout.topMargin: 25
                //% "Sent amount"
                title:            qsTrId("sent-amount-label")
                id:               sendAmountInput
                hasFee:           true
                amount:           viewModel.sendAmount
                currency:         viewModel.sendCurrency
                readOnlyA:        true
                multi:            false
                color:            Style.accent_outgoing
                currColor:        viewModel.receiveCurrency == viewModel.sendCurrency ? Style.validator_error : Style.content_main
                //% "There is not enough funds to completer the transaction"
                error:            viewModel.isEnough ? "" : qsTrId("send-not-enough")
            }

            Binding {
                target:   viewModel
                property: "sendFee"
                value:    sendAmountInput.fee
            }

            //
            // Comment
            //
            SFText {
                Layout.topMargin: 25
                font.pixelSize:   14
                font.styleName:   "Bold"; font.weight: Font.Bold
                color:            Style.content_main
                //% "Comment"
                text:             qsTrId("general-comment")
            }

            SFTextInput {
                id:               comment_input
                Layout.fillWidth: true
                font.pixelSize:   14
                color:            Style.content_main
                selectByMouse:    true
                maximumLength:    BeamGlobals.maxCommentLength()
            }

            Item {
                Layout.fillWidth: true
                SFText {
                    Layout.alignment: Qt.AlignTop
                    color:            Style.content_secondary
                    font.italic:      true
                    font.pixelSize:   12
                    //% "Comments are local and won't be shared"
                    text:             qsTrId("general-comment-local")
                }
            }

            Binding {
                target:   viewModel
                property: "comment"
                value:    comment_input.text
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            width: parent.width / 2 - parent.columnSpacing / 2

            //
            // Receive Amount
            //
            AmountInput {
                Layout.topMargin: 25
                //% "Receive amount"
                title:            qsTrId("receive-amount-swap-label")
                id:               receiveAmountInput
                hasFee:           true
                amount:           viewModel.receiveAmount
                currency:         viewModel.receiveCurrency
                readOnlyA:        true
                multi:            false
                color:            Style.accent_incoming
                currColor:        viewModel.receiveCurrency == viewModel.sendCurrency ? Style.validator_error : Style.content_main
            }

            Binding {
                target:   viewModel
                property: "receiveFee"
                value:    receiveAmountInput.fee
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.topMargin: 25
                columnSpacing:    30
                columns:          2

                ColumnLayout {
                    SFText {
                        font.pixelSize:   14
                        font.styleName:   "Bold"; font.weight: Font.Bold
                        color:            Style.content_main
                        //% "Offered on"
                        text:             qsTrId("wallet-send-swap-offered-label")
                    }

                    SFText {
                        Layout.topMargin: 10
                        id:               offered
                        font.pixelSize:   14
                        color:            Style.content_secondary
                        text:             Utils.formatDateTime(viewModel.offeredTime, BeamGlobals.getLocaleName())
                    }
                }

                ColumnLayout {
                    SFText {
                        id:               expiresTitle
                        font.pixelSize:   14
                        font.styleName:   "Bold"; font.weight: Font.Bold
                        color:            Style.content_main
                        //% "Expires on"
                        text:             qsTrId("wallet-send-swap-expires-label")
                    }

                    SFText {
                        id:               expires
                        Layout.topMargin: 10
                        font.pixelSize:   14
                        color:            Style.content_secondary
                        text:             Utils.formatDateTime(viewModel.expiresTime, BeamGlobals.getLocaleName())
                    }
                }
            }

            SFText {
                Layout.topMargin: 18
                font.pixelSize:   14
                font.weight:      Font.Bold
                color:            Style.content_main
                //% "Rate"
                text:             qsTrId("general-rate")
            }

            SFText {
                id:               rate
                Layout.topMargin: 3
                font.pixelSize:   14
                color:            Style.content_secondary
                text:             ["1", sendAmountInput.currencyLabel, "=", Utils.calcDisplayRate(sendAmountInput, receiveAmountInput), receiveAmountInput.currencyLabel].join(" ")
            }
        }
    }

    Row {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 60
        spacing:          25

        CustomButton {
            text:                qsTrId("general-close")
            palette.buttonText:  Style.content_main
            icon.source:         "qrc:/assets/icon-cancel-white.svg"
            onClicked:           thisView.parent.parent.pop();
        }

        CustomButton {
            //% "Swap"
            text:               qsTrId("wallet-swap")
            palette.buttonText: Style.content_opposite
            palette.button:     Style.accent_outgoing
            icon.source:        "qrc:/assets/icon-send-blue.svg"
            enabled:            viewModel.canSend
            onClicked: {
                const dialog       = Qt.createComponent("send_confirm.qml").createObject(thisView);
                dialog.addressText = viewModel.receiverAddress;
                dialog.amountText  = [Utils.formatAmount(viewModel.sendAmount), sendAmountInput.getCurrencyLabel()].join(" ")
                dialog.feeText     = [Utils.formatAmount(viewModel.sendFee), sendAmountInput.getFeeLabel()].join(" ")
                dialog.open();
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
