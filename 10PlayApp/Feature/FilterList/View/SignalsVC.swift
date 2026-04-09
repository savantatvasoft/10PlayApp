//
//  SignalsVC.swift
//  10PlayApp
//
//  Created by savan soni on 09/04/26.
//

import UIKit
import PhotosUI

class SignalsVC: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var header: Header!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var projectNameContainer: DropDownContainer!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var codePostalLabel: UILabel!
    @IBOutlet weak var codePostalTextField: UITextField!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var photoDescriptionLabel: UILabel!
    @IBOutlet weak var firstImage: UIButton!
    @IBOutlet weak var secondImage: UIButton!
    @IBOutlet weak var thirdImage: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var firstRating: UIButton!
    @IBOutlet weak var secondRating: UIButton!
    @IBOutlet weak var thirdRating: UIButton!
    @IBOutlet weak var fourthRating: UIButton!
    @IBOutlet weak var fifthRating: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var validateBtnView: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!

    @IBOutlet weak var onValidate: UIButton!
    private var currentRating: Int = 0
    private var ratingButtons: [UIButton] {
        [firstRating, secondRating, thirdRating, fourthRating, fifthRating]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    
    @IBAction func onPressFirstRating(_ sender: Any)  { handleRating(at: 1) }
    @IBAction func onPressSecondRating(_ sender: Any) { handleRating(at: 2) }
    @IBAction func onPressThirdRating(_ sender: Any)  { handleRating(at: 3) }
    @IBAction func onPressFourthRating(_ sender: Any) { handleRating(at: 4) }
    @IBAction func onPressFifthRating(_ sender: Any)  { handleRating(at: 5) }
    
    @IBAction func onPressFirstImage(_ sender: Any) {
        firstImage.tag = 1
        openImagePicker(for: firstImage)
    }

    @IBAction func onPressSecondImage(_ sender: Any) {
        secondImage.tag = 2
        openImagePicker(for: secondImage)
    }

    @IBAction func onPressThirdImage(_ sender: Any) {
        thirdImage.tag = 3
        openImagePicker(for: thirdImage)
    }
    
    @IBAction func onPressValidatet(_ sender: Any) {
        showValidationPopup()
    }
}

extension SignalsVC {
    
    func setUp() {
        setupHeader()
        applyTypography()
        applyLocalizations()
        updateRatingUI()
        setupBottomViewStyle()
        setupImageButtons()
        textView.delegate = self
    }
    
    private func applyTypography() {
        [addressLabel, cityLabel, streetLabel, codePostalLabel].forEach {
            $0?.font = AppFont.get(.bold, size: 12.5)
        }
        
        [cityTextField, streetTextField, codePostalTextField].forEach {
            $0?.font = AppFont.get(.regular, size: 14)
        }
        
        photoDescriptionLabel.font = AppFont.get(.regular, size: 12)
        
        [photoLabel, addressLabel, ratingLabel, commentLabel].forEach {
            $0?.font = AppFont.get(.extraBold, size: 13)
            $0?.textColor = UIColor(named: "RedColor")
        }
        
        placeholderLabel.font =  AppFont.get(.regular, size: 14)
        textView.font =  AppFont.get(.regular, size: 14)
        projectNameContainer.topLabel.textColor = UIColor(named: "RedColor")
    }
    
    private func applyLocalizations() {
        addressLabel.text = "location_address".localized
        cityLabel.text = "city".localized
        streetLabel.text = "street".localized
        codePostalLabel.text = "code".localized
        ratingLabel.text = "rating".localized
        photoLabel.text = "photo".localized
        photoDescriptionLabel.text = "photo_desc".localized
        commentLabel.text = "comment".localized
        placeholderLabel.text = "add_commnt".localized
        
        projectNameContainer.configure(
            label: "project_name".localized,
            title: "project_default".localized,
            items: projectItems,
            topSpace: 10
        )
    }
    
    private func setupHeader() {
        enabelBackAction = true
        header.centerTitle.text     = "signal_title".localized
        header.centerIcon.isHidden  = true
        header.centerTitle.isHidden = false
        header.leftImage.setImage(UIImage(named: "Ico_back_nav_menu"), for: .normal)
        header.rightImage.setImage(UIImage(named: "ic_10_play_white"), for: .normal)
        attachHeader(header)
    }
    
    private func setupBottomViewStyle() {
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 10.0
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -5)
        bottomView.layer.masksToBounds = false
        bottomView.clipsToBounds = false
        
        validateBtnView.setStyle(weight: .bold, size: 13,horizontalPadding: 35,verticalPadding: 8)
    }
    
    private func showValidationPopup() {
        ForgotPasswordPopUp.show(
            in: self.view,
            message: "mission_alert".localized
        ) { _ in
           print("")
        }
    }
}

// MARK: - Rating
extension SignalsVC {
    
    private func handleRating(at index: Int) {
        guard index != currentRating else { return }
        currentRating = index
        updateRatingUI()
    }
    
    private func updateRatingUI() {
        ratingButtons.enumerated().forEach { i, button in
            button.tintColor = i < currentRating ? UIColor(named: "Yellow")  : .systemGray4
        }
    }
}


extension SignalsVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}


// MARK: - Image Picker
extension SignalsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func openImagePicker(for button: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.view.tag = button.tag
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        let tag = picker.view.tag
        
        switch tag {
        case 1: setImage(image!, to: firstImage)
        case 2: setImage(image!, to: secondImage)
        case 3: setImage(image!, to: thirdImage)
        default: break
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    private func setImage(_ image: UIImage, to button: UIButton?) {
        guard let button else { return }
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.clipsToBounds = true
        button.layer.cornerRadius = 8  // ← consistent corner radius
        button.contentEdgeInsets = .zero  // ← remove any padding
        button.imageEdgeInsets = .zero    // ← remove image insets
    }
    
    private func setupImageButtons() {
        [firstImage, secondImage, thirdImage].forEach { button in
            guard let button else { return }
            button.clipsToBounds = true
            button.layer.cornerRadius = 8
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.imageView?.contentMode = .scaleAspectFill
            
            // Fixed size
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 100),
                button.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
}
