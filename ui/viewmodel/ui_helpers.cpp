#include "ui_helpers.h"

#include <QDateTime>
#include <QLocale>
#include <numeric>

using namespace std;
using namespace beam;

namespace beamui
{
    QString toString(const beam::wallet::WalletID& walletID)
    {
        if (walletID != Zero)
        {
            auto id = std::to_string(walletID);
            return QString::fromStdString(id);
        }
        return "";
    }

    QString toString(const beam::Merkle::Hash& walletID)
    {
        auto id = std::to_string(walletID);
        return QString::fromStdString(id);
    }
    
    QString AmountToString(const Amount& value, Currencies coinType)
    {
        auto realAmount = double(int64_t(value)) / Rules::Coin;
        QString amount = QLocale().toString(realAmount, 'f', QLocale::FloatingPointShortest);

        QString coinSign;
        switch (coinType)
        {
            case Currencies::Beam:
                coinSign = QString::fromUtf16((const char16_t*)(L" \uEAFB"));
                break;

            case Currencies::Bitcoin:
                coinSign = QString::fromUtf16((const char16_t*)(L" \u20BF"));
                break;

            case Currencies::Litecoin:
                coinSign = QString::fromUtf16((const char16_t*)(L" \u0141"));
                break;

            case Currencies::Qtum:
                coinSign = QString::fromUtf16((const char16_t*)(L" \uFFFD"));
                break;

            case Currencies::Unknown:
                coinSign = "";
                break;
        }
        return amount + coinSign;
    }

    QString toString(const beam::Timestamp& ts)
    {
        QDateTime datetime;
        datetime.setTime_t(ts);

        return datetime.toString(Qt::SystemLocaleShortDate);
    }

    double Beam2Coins(const Amount& value)
    {
        return double(int64_t(value)) / Rules::Coin;
    }

    Currencies convertSwapCoinToCurrency(wallet::AtomicSwapCoin coin)
    {
        switch (coin)
        {
        case wallet::AtomicSwapCoin::Bitcoin:
            return beamui::Currencies::Bitcoin;
        case wallet::AtomicSwapCoin::Litecoin:
            return beamui::Currencies::Litecoin;
        case wallet::AtomicSwapCoin::Qtum:
            return beamui::Currencies::Qtum;
        case wallet::AtomicSwapCoin::Unknown:
        default:
            return beamui::Currencies::Unknown;
        }
    }

    Filter::Filter(size_t size)
        : _samples(size, 0.0)
        , _index{0}
        , _is_poor{true}
    {
    }
    
    void Filter::addSample(double value)
    {
        _samples[_index] = value;
        _index = (_index + 1) % _samples.size();
        if (_is_poor)
        {
            _is_poor = _index + 1 < _samples.size();
        }
    }

    double Filter::getAverage() const
    {
        double sum = accumulate(_samples.begin(), _samples.end(), 0.0);
        return sum / (_is_poor ? _index : _samples.size());
    }

    double Filter::getMedian() const
    {
        vector<double> temp(_samples.begin(), _samples.end());
        size_t medianPos = (_is_poor ? _index : temp.size()) / 2;
        nth_element(temp.begin(),
                    temp.begin() + medianPos,
                    _is_poor ? temp.begin() + _index : temp.end());
        return temp[medianPos];
    }

    QDateTime CalculateExpiresTime(beam::Height currentHeight, beam::Height expiresHeight)
    {
        auto currentDateTime = QDateTime::currentDateTime();
        QDateTime expiresTime = currentDateTime;

        if (currentHeight <= expiresHeight)
        {
            expiresTime = currentDateTime.addSecs((expiresHeight - currentHeight) * 60);
        }
        else
        {
            auto dateTimeSecs = currentDateTime.toSecsSinceEpoch() - (currentHeight - expiresHeight) * 60;
            expiresTime.setSecsSinceEpoch(dateTimeSecs);
        }

        return expiresTime;
    }

    QString toString(Currencies currency)
    {
        switch(currency)
        {
            case Currencies::Beam: return "beam";
            case Currencies::Bitcoin: return "btc";
            case Currencies::Litecoin: return "ltc";
            case Currencies::Qtum: return "qtum";
            default: return "unknown";
        }
    }

    std::string toStdString(Currencies currency)
    {
        return toString(currency).toStdString();
    }
}  // namespace beamui
