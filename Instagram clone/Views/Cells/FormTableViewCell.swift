//
//  FormTableViewCell.swift
//  Instagram clone
//
//  Created by Suraj Rawat on 09/11/21.
//

import UIKit

protocol FormTableViewCellDelegate: AnyObject {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel )
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "FormTableViewCell"
    
    private var model: EditProfileFormModel?
    
    public weak var delegate: FormTableViewCellDelegate?
    
    private let formlabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formlabel)
        contentView.addSubview(field)
        selectionStyle = .none
        field.delegate = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    public func configure(with model: EditProfileFormModel) {
        self.model = model
        formlabel.text = model.label
        field.placeholder = field.placeholder
        field.text = model.value
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        formlabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        assign frames
        formlabel.frame = CGRect(x: 5,
                                 y: 0,
                                 width: contentView.width/3,
                                 height: contentView.height)
        field.frame = CGRect(x: formlabel.right + 5,
                             y: 0,
                             width: contentView.width-10-formlabel.width,
                             height: contentView.height)
    }
    
    //    MARK: - Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else {
            return true
        }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
    
}
