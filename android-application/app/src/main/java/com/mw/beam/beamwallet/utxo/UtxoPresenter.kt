package com.mw.beam.beamwallet.utxo

import com.mw.beam.beamwallet.baseScreen.BasePresenter

/**
 * Created by vain onnellinen on 10/2/18.
 */
class UtxoPresenter(currentView: UtxoContract.View, private val model: UtxoModel)
    : BasePresenter<UtxoContract.View>(currentView),
        UtxoContract.Presenter {
    override fun viewIsReady() {
        super.viewIsReady()
        view?.configData(model.wallet)
    }
}