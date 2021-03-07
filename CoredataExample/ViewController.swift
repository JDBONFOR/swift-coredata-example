import UIKit
import CoreData

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var yearTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    // MARK: - Vars
    private var context: NSManagedObjectContext!
        
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - IBActions
extension ViewController {
    
    @IBAction func saveUser(_ sender: Any) {
        
        let entityStudent = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context) as! Student
        
        guard let nombre = nameTextField.text, let age = Int16(yearTextField.text!), let address = addressTextField.text else { return }
        
        entityStudent.nombre = nombre
        entityStudent.edad = age
        entityStudent.direccion = address
        entityStudent.activo = activeSwitch.isOn
        
        do {
            
            try context.save()
            clearForm()
            
            print("Guardado correctamente en CoreData Student")
        } catch let error as NSError {
            print("Error al guardar ==> \(error.localizedDescription)")
        }
    }
    
    @IBAction func showData(_ sender: Any) {
        
        let coreDataInfo: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            
            let students = try context.fetch(coreDataInfo)
            print("Numero de registros ==> \(students.count)")
            
            for student in students as [NSManagedObject] {
                let nombre = student.value(forKey: "nombre")
                let edad = student.value(forKey: "edad")
                let direccion = student.value(forKey: "direccion")
                let activo = student.value(forKey: "activo")
                
                print("Nombre: \(nombre ?? "Sin nombre"), Edad: \(edad ?? "Sin edad"), Direccion: \(direccion ?? "Sin direccion"), Activo: \(activo ?? "activo N/A")")
            }
            
        } catch let error as NSError {
            print("Error al leer la información ==> \(error.localizedDescription)")
        }
        
    }
 
    @IBAction func removeData(_ sender: Any) {
        
        let coreDataInfo = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let removeRequest = NSBatchDeleteRequest(fetchRequest: coreDataInfo)
        
        
        do {
            try context.execute(removeRequest)
            print("Data eliminada")
        } catch let error as NSError {
            print("Error al eliminar la información ==> \(error.localizedDescription)")
        }
    }
}

// MARK: - Private Methods
private extension ViewController {
    
    func setupUI() {
        context = connectToCoreData()
    }
    
    func connectToCoreData() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    func clearForm() {
        nameTextField.text = ""
        yearTextField.text = ""
        addressTextField.text = ""
    }

}
