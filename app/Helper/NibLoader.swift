import UIKit

public class NibLoader {

    static func load<T: UIView>(type: T.Type) -> T? {
        return Bundle.main.loadNibNamed(type.identifier, owner: nil, options: nil)?.first as? T
    }

    public static func loadViewFromNib(name: String, owner: Any, nibType: AnyClass) -> UIView {
        let bundle = Bundle(for: nibType)
        let nib = UINib(nibName: name, bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = (nib.instantiate(withOwner: owner, options: nil)[0] as? UIView) ?? UIView()
        return view
    }
}
