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
#include "kdf.h"

typedef struct
{
	BeamCrypto_CoinID m_Cid;
	const BeamCrypto_Kdf* m_pKdf; // master kdf

	const secp256k1_scalar* m_pKExtra; // optionally embed 2 scalars that can be recognized (in addition to CoinID)

	BeamCrypto_Point m_pT[2]; // in/out
	secp256k1_scalar m_TauX; // result

} BeamCrypto_RangeProof;

int BeamCrypto_RangeProof_Calculate(BeamCrypto_RangeProof*);
