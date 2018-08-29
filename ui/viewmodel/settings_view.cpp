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

#include "settings_view.h"
#include "version.h"
#include <QtQuick>
#include "model/app_model.h"

using namespace std;

SettingsViewModel::SettingsViewModel()
    : m_settings{AppModel::getInstance()->getSettings()}
{

}


QString SettingsViewModel::getNodeAddress() const
{
    return m_settings.getNodeAddress();
}

QString SettingsViewModel::version() const
{
    return QString::fromStdString(PROJECT_VERSION);
}

void SettingsViewModel::applyChanges(const QString& addr)
{
    m_settings.setNodeAddress(addr);
    emit nodeAddressChanged();
}

void SettingsViewModel::emergencyReset()
{
    m_settings.emergencyReset();
}

void SettingsViewModel::reportProblem()
{
	m_settings.reportProblem();
}