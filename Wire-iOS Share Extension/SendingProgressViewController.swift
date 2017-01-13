//
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation
import WireExtensionComponents
import WireShareEngine
import Cartography

class SendingProgressViewController : UIViewController {

    var cancelHandler : (() -> Void)?
    
    private var circularShadow  = CircularProgressView()
    private var circularProgress  = CircularProgressView()
    private let minimumProgress : Float = 0.125
    
    var progress: Float = 0 {
        didSet {
            let adjustedProgress = (progress / (1 + minimumProgress)) + minimumProgress
            circularProgress.setProgress(adjustedProgress, animated: true)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "share_extension.sending_progress.title".localized
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelTapped))
        
        circularShadow.lineWidth = 2
        circularShadow.setProgress(1, animated: false)
        circularShadow.alpha = 0.2
        
        circularProgress.lineWidth = 2
        circularProgress.setProgress(0, animated: false)
    
        view.addSubview(circularShadow)
        view.addSubview(circularProgress)
        
        constrain(view, circularShadow, circularProgress) { container, circularShadow, circularProgress in
            circularShadow.width == 48
            circularShadow.height == 48
            circularShadow.center == container.center
            
            circularProgress.width == 48
            circularProgress.height == 48
            circularProgress.center == container.center
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        circularProgress.setProgress(minimumProgress, animated: true)
    }
    
    func onCancelTapped() {
        cancelHandler?()
    }

}