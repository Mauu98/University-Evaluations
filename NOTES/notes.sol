// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 < 0.7.0;
pragma experimental ABIEncoderV2;

contract notas {
    
    // Direccion del profesor
    address public professor;
    
    // Constructor 
    constructor () public {
        professor = msg.sender;
    }
    
    // Mapping para relacionar el hash de la identidad del alumno con su nota
    mapping (bytes32 => uint) Notes;
    
    // Array de los alumnos que pidan revisiones de examen
    string [] revisions;
    
    // Eventos 
    event evaluated_student(bytes32, uint);
    event revision(string);
    
    // Funcion para evaluar a alumnos
    function evaluate(string memory _studentId, uint _note) public professorUnique(msg.sender){
        // Hash de la identificacion del alumno 
        bytes32 hash_studentId = keccak256(abi.encodePacked(_studentId));
        // Relacion entre el hash de la identificacion del alumno y su nota
        Notes[hash_studentId] = _note;
        // Emision del evento
        emit evaluated_student(hash_studentId, _note);
    }
    

    modifier professorUnique(address _professorAddress){
        // Requiere que la direccion introducido por parametro sea igual al propietario del contrato
        require(_professorAddress == professor, "No tienes permisos para ejecutar esta función!");
        _;
    }

    // Función para ver las notas de un estudiante
    function seeNotes(string memory _studentId) public view returns(uint){
        bytes32 hash_studentId = keccak256(abi.encodePacked(_studentId));

        //Nota asociada al hash del estudiante
        uint studentNote = Notes[hash_studentId];

        return studentNote;
    }

    //Función para pedir revisión de notas
    function askToSeeNotes(string memory _studentId) public {
        //Guardar con más seguridad -> bytes32 hash_studentId = keccak256(abi.encodePacked(_studentId));
        revisions.push(_studentId);

        emit revision(_studentId);
    }

    //Función para ver los alumnos que solicitaron la revisión del exámen
    function seeRevisions() public view professorUnique(msg.sender) returns(string[] memory){
        return revisions;
    }
}