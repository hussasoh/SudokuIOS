// Copyright (c) 2016-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import MobileCoreServices
import UIKit

import FacebookShare

final class ShareDialogViewController: UIViewController,
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate,
    
SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        //show success message
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        //show error message
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        //show cancelled message
    }
    

  func showShareDialog<C: SharingContent>(_ content: C, mode: ShareDialog.Mode = .automatic) {
    let dialog = ShareDialog(fromViewController: self, content: content, delegate: self)
    dialog.mode = mode
    dialog.show()
  }

  // sharing the link
    
    @IBAction func shareScore(_sender: UIButton) {
    guard let url = URL(string: "https://github.com/hussasoh/SudokuIOS") else { return }
    let content = ShareLinkContent()
    content.contentURL = url
    content.quote = "Take a look at our Sudoko App! My high score was: "

    showShareDialog(content, mode: .automatic)
  }
  
}
