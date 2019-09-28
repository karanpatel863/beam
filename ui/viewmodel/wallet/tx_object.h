// Copyright 2018 The Beam Team
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#pragma once

#include <QObject>
#include <QDateTime>
#include "viewmodel/payment_item.h"
#include "viewmodel/ui_helpers.h"

class TxObject : public QObject
{
    Q_OBJECT

public:
    TxObject(QObject* parent = nullptr);
    TxObject(const beam::wallet::TxDescription& tx, QObject* parent = nullptr);

    auto timeCreated() const -> QDateTime;
    auto getTxID() const -> beam::wallet::TxID;
    auto getAmount() const -> QString;
    auto getAmountValue() const -> double;
    auto getSentAmount() const -> QString;
    auto getSentAmountValue() const -> double;
    auto getReceivedAmount() const -> QString;
    auto getReceivedAmountValue() const -> double;
    auto getStatus() const -> QString;
    auto getComment() const -> QString;
    auto getAddressFrom() const -> QString;
    auto getAddressTo() const -> QString;
    auto getFee() const -> QString;
    auto getKernelID() const -> QString;
    auto getTransactionID() const -> QString;
    auto getFailureReason() const -> QString;
    auto hasPaymentProof() const -> bool;

    bool isIncome() const;
    bool isCancelAvailable() const;
    bool isDeleteAvailable() const;
    bool isInProgress() const;
    bool isCompleted() const;
    bool isSelfTx() const;

    auto isBeamSideSwap() const -> bool;
    auto getSwapCoinName() const -> QString;

    void setKernelID(const QString& value);
    void setStatus(beam::wallet::TxStatus status);
    void setFailureReason(beam::wallet::TxFailureReason reason);
    void update(const beam::wallet::TxDescription& tx);

signals:
    void statusChanged();
    void kernelIDChanged();
    void failureReasonChanged();

private:
    auto getTxDescription() const -> const beam::wallet::TxDescription&;
    QString getSwapAmount(bool sent) const;
    double getSwapAmountValue(bool sent) const;

    beam::wallet::TxDescription m_tx;
    QString m_kernelID;
    beam::wallet::TxType m_type;
};
