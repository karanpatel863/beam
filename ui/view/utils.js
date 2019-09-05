function formatDateTime(datetime, localeName) {
    var maxTime = new Date(4294967295000);
    if (datetime >= maxTime) {
        //: time never string
        //% "Never"
        return qsTrId("time-never");
    }
    var timeZoneShort = datetime.getTimezoneOffset() / 60 * (-1);
    return datetime.toLocaleDateString(localeName)
         + " | "
         + datetime.toLocaleTimeString(localeName)
         + (timeZoneShort >= 0 ? " (GMT +" : " (GMT ")
         + timeZoneShort
         + ")";
}

function formatAmount (amount, toPlainNumber) {
    return amount ? amount.toLocaleString(toPlainNumber ? Qt.locale("C") : Qt.locale(), 'f', -128) : ""
}

function getLogoTopGapSize(parentHeight) {
    return parentHeight * (parentHeight < 768 ? 0.13 : 0.18)
}

function handleMousePointer(mouse, element) {
    element.cursorShape = element.parent.linkAt(mouse.x, mouse.y).length
        ? element.cursorShape = Qt.PointingHandCursor
        : element.cursorShape = Qt.ArrowCursor;
}

function openExternal(externalLink, settings, dialog) {
    if (settings.isAllowedBeamMWLinks) {
        Qt.openUrlExternally(externalLink);
    } else {
        dialog.externalUrl = externalLink;
        dialog.onOkClicked = function () {
            settings.isAllowedBeamMWLinks = true;
        };
        dialog.open();
    }
}

function handleExternalLink(mouse, element, settings, dialog) {
    if (element.cursorShape == Qt.PointingHandCursor) {
        var externalLink = element.parent.linkAt(mouse.x, mouse.y);
        if (settings.isAllowedBeamMWLinks) {
            Qt.openUrlExternally(externalLink);
        } else {
            dialog.externalUrl = externalLink;
            dialog.onOkClicked = function () {
                settings.isAllowedBeamMWLinks = true;
            };
            dialog.open();
        }
    } else {
        settings.isAllowedBeamMWLinks = !settings.isAllowedBeamMWLinks;
    }
}

function calcDisplayRate(ail, air) {
    // ai[X] = amount input control
    var cl = ail.currency
    var cr = air.currency
    if (cl == cr) return 1;

    var al = ail.amount
    var ar = air.amount
    if (al == 0 || ar == 0) return "?"

    var rounder = 100000000
    return Math.round(ar / al * rounder) / rounder
}

function currenciesList() {
    return ["BEAM", "BTC", "LTC", "QTUM"]
}

const symbolBeam  = '\uEAFB'
const symbolBtc   = '\u20BF'
const symbolLtc   = '\u0141'
const symbolQtum  = '\uFFFD' // TODO:SWAP change when available