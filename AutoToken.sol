pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract AutoToken {

struct Token { // структура токена
    string model; //модель автомобиля
    uint energy; // мощность автомобиля
    uint maxSpeed;  // максимальная скорость автомобиля
}
// создаем массив токенов (автомобилей), сюда будем записывать свежесозданный токен
Token[] autoArr; 

//сопоставление с направлением одних целых чисел на другие
//в качестве ключа выступает ключ токена
mapping(uint => uint) tokenToOwner;

//модификатор с проверкой 
modifier checkNameToken {
		require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
		_;
	}

    //функция по созданию токена
function creatToken(string model, uint energy, uint maxSpeed) public checkNameToken {
    tvm.accept(); //подтверждение оплаты
    
    // создаем новый токен, вызываем токен с передачей необходимых параметров и записываем в массив autoArr
    autoArr.push(Token (model, energy, maxSpeed)); 
    require(model == model, 101); //проверка токена на уникальность имени
    //переменная ключа
    uint keyAsLastNum = autoArr.length - 1;
    // прописываем сопоставлению,что из нашего ключа ссылаемся на владельца
    //msg.pubkey() возвращает открытый ключ отправителя, полученный из тела внешнего входящего сообщения
    tokenToOwner[keyAsLastNum] = msg.pubkey(); 
    //require(tokenToOwner.exists(keyAsLastNum), 101); //проверка токена на уникальность имени??
}    

// функция владелец токена
function getTokenOwner (uint tokenID) public view returns(uint) { //view: для возвращения значения локально, tvm.accept() не указываем в теле функции
    return tokenToOwner[tokenID]; //возвращаем входящее значение tokenID
}

//функция по токену в целом (информация)
function getTokenInfo(uint tokenId) public view returns(string tokenModel, uint tokenEnergy, uint tokenMaxSpeed){
    // tvm.accept();
    // ничего возращать не будем, так как мы указали названия, заполняем tokenModel, tokenEnergy tokenMaxSpeed
    tokenModel = autoArr[tokenId].model; 
    tokenEnergy = autoArr[tokenId].energy;
    tokenMaxSpeed = autoArr[tokenId].maxSpeed;
}
// функция проверки на права, на передачу токена (подарок)
function changeOwner (uint tokenId, uint pubkeyofNewOwner) public {
    require(msg.pubkey() == tokenToOwner[tokenId], 101); // проверка владельца токена
    tvm.accept(); //подтверждение оплаты
    tokenToOwner[tokenId] = pubkeyofNewOwner; //присваиваем публичный ключ новому владельцу
}
// приватная функция продажи токена владельцем
function putTokenForSale() private view returns (uint) {
    uint price = 1000;
}

}
