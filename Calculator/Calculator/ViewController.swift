import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calculatorWorkings: UILabel!
    @IBOutlet weak var calculatorResults: UILabel!
    
    var workings = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
    }
    
    func clearAll() {
        workings = ""
        calculatorWorkings.text = ""
        calculatorResults.text = "0"
    }
    
    func addToWorkings(value: String) {
        workings += value
        calculatorWorkings.text = workings
    }

    func formatResult(result: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        
        return formatter.string(from: NSNumber(value: result)) ?? "0"
    }

    func specialOperator(_ char: Character) -> Bool {
        return ["+", "-", "×", "÷"].contains(char)
    }
    
    func validInput() -> Bool {
        if workings.isEmpty { return false }
        if (workings == "+" || workings == "×" || workings == "÷" || workings == "." || workings == "%") {
            return false
        }
        var previousIsOperator = false
        
        for (i, char) in workings.enumerated() {
            if specialOperator(char) {
                if i == 0 && char != "-" {
                    return false
                }
                
                if previousIsOperator {
                    return false
                }
                previousIsOperator = true
            }
            else {
                previousIsOperator = false
            }
        }
        
        if let last = workings.last, specialOperator(last) {
            return false
        }
        
        return true
    }

    @IBAction func allClearTap(_ sender: Any) {
        clearAll()
    }
    
    @IBAction func backTap(_ sender: Any) {
        if !workings.isEmpty {
            workings.removeLast()
            calculatorWorkings.text = workings
        }
    }
    
    @IBAction func percentTap(_ sender: Any) {
        addToWorkings(value: "%")
    }
    
    @IBAction func divideTap(_ sender: Any) {
        addToWorkings(value: "÷")
    }
    
    @IBAction func multiplyTap(_ sender: Any) {
        addToWorkings(value: "×")
    }
    
    @IBAction func minusTap(_ sender: Any) {
        addToWorkings(value: "-")
    }
    
    @IBAction func addTap(_ sender: Any) {
        addToWorkings(value: "+")
    }
    
    @IBAction func nineTap(_ sender: Any) { addToWorkings(value: "9") }
    @IBAction func eightTap(_ sender: Any) { addToWorkings(value: "8") }
    @IBAction func sevenTap(_ sender: Any) { addToWorkings(value: "7") }
    @IBAction func sixTap(_ sender: Any) { addToWorkings(value: "6") }
    @IBAction func fiveTap(_ sender: Any) { addToWorkings(value: "5") }
    @IBAction func fourTap(_ sender: Any) { addToWorkings(value: "4") }
    @IBAction func threeTap(_ sender: Any) { addToWorkings(value: "3") }
    @IBAction func twoTap(_ sender: Any) { addToWorkings(value: "2") }
    @IBAction func oneTap(_ sender: Any) { addToWorkings(value: "1") }
    @IBAction func zeroTap(_ sender: Any) { addToWorkings(value: "0") }
    
    @IBAction func decimalTap(_ sender: Any) {
        let lastSegment = workings.components(separatedBy: CharacterSet(charactersIn: "+-×÷")).last ?? ""
        if !lastSegment.contains(".") {
            addToWorkings(value: ".")
        }
    }

    @IBAction func equalTap(_ sender: Any) {
        if !validInput() {
            showError()
            return
        }
        
        var expressionString = workings
        
        if expressionString.contains("%") {
            expressionString = expressionString.replacingOccurrences(of: "%", with: "*0.01")
        }
        
        expressionString = expressionString.replacingOccurrences(of: "÷", with: "*1.0/")
        expressionString = expressionString.replacingOccurrences(of: "×", with: "*")
        
        let expression = NSExpression(format: expressionString)
        
        if let result = expression.expressionValue(with: nil, context: nil) as? Double {
            if result.isInfinite || result.isNaN {
                calculatorResults.text = "Error"
            }
            else {
                calculatorResults.text = formatResult(result: result)
            }
        }
        else {
            calculatorResults.text = "Error"
        }
    }
    
    func showError() {
        let alert = UIAlertController(title: "Error", message: "Please enter a valid expression", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
