import QtQuick.Layouts 1.11
import QtQuick 2.11
import Beam.Wallet 1.0
import "../utils.js" as Utils
import Beam.Wallet 1.0

ColumnLayout {
    id: control

    property bool    fillWidth: false
    property bool    readOnly:  false
    property int     minFee:    0
    property int     fee:       0
    property string  feeLabel:  undefined
    property string  color:     Style.content_main
    readonly property bool isValid: control.fee >= control.minFee

    RowLayout {
        Layout.fillWidth: true

        SFTextInput {
            id:                    feeInput
            Layout.fillWidth:      control.fillWidth
            Layout.preferredWidth: 150
            font.pixelSize:        14
            font.styleName:        "Light"
            font.weight:           Font.Light
            font.italic:           !isValid
            color:                 isValid ? control.color : Style.validator_error
            backgroundColor:       isValid ? Style.content_main : Style.validator_error
            maximumLength:         9
            selectByMouse:         true
            validator:             IntValidator {bottom: control.minFee}
            readOnly:              control.readOnly

            function formatFee() {
                return control.fee ? control.fee.toLocaleString(focus ? Qt.locale("C") : Qt.locale(), 'f', -128) : ""
            }

            onTextEdited:   control.fee = text ? parseInt(text) : 0
            onFocusChanged: text = formatFee()

            Connections {
                target: control
                onFeeChanged: feeInput.text = feeInput.formatFee()
                Component.onCompleted: feeInput.text = feeInput.formatFee()
            }
        }

        SFText {
            font.pixelSize: 14
            color:          Style.content_main
            text:           control.feeLabel
            visible:        (control.feeLabel || "").length
        }
    }

    Item {
        Layout.fillWidth: true
        SFText {
            //% "The minimum fee is %1 %2"
            text:            qsTrId("general-fee-fail").arg(Utils.formatAmount(control.minFee)).arg(control.feeLabel)
            color:           Style.validator_error
            font.pixelSize:  12
            font.styleName:  "Italic"
            width:           parent.width
            visible:         !control.isValid
        }
    }
}