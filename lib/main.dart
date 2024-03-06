// Importações necessárias para o funcionamento do aplicativo
import 'package:flutter/material.dart'; // Pacote para desenvolvimento de interfaces
import 'dart:async'; // Pacote para lidar com temporizadores

void main() {
  runApp(const MyApp()); // Inicialização do aplicativo
}

// Classe principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Método responsável por construir a interface do aplicativo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoramento de Robô Industrial', // Título do aplicativo
      debugShowCheckedModeBanner: false, // Remove a faixa de debug no canto superior direito
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a cor primária do aplicativo
      ),
      home: RobotMonitorScreen(), // Define a tela inicial como RobotMonitorScreen
    );
  }
}

// Classe que define a tela de monitoramento do robô
class RobotMonitorScreen extends StatefulWidget {
  const RobotMonitorScreen({Key? key}) : super(key: key);

  @override
  _RobotMonitorScreenState createState() => _RobotMonitorScreenState();
}

// Estado da tela de monitoramento do robô
class _RobotMonitorScreenState extends State<RobotMonitorScreen> {
  double temperature = 0.0; // Variável que armazena a temperatura atual do robô
  bool isOperating = false; // Indica se o robô está ligado ou desligado
  bool isCountingDown = false; // Indica se a contagem regressiva está em andamento
  bool isButtonEnabled = true; // Indica se o botão "Ligar Robô" está ativado ou desativado

  // Método que constrói a interface da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoramento de Robô Industrial'), // Título da barra de navegação
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Exibe a temperatura atual do robô
            Text(
              'Temperatura: ${temperature.toStringAsFixed(1)} °C',
              style: const TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0), // Espaçamento entre os widgets
            ElevatedButton(
              // Botão para ligar ou desligar o robô
              onPressed: !isOperating || (isOperating && temperature == 75)
                  ? () {
                      setState(() {
                        if (isOperating) {
                          isOperating = false; // Desliga o robô
                          isCountingDown = true; // Inicia a contagem regressiva
                          isButtonEnabled = false; // Desativa o botão "Ligar Robô"
                          _turnOffRobot(); // Desliga o robô
                        } else {
                          isOperating = true; // Liga o robô
                          isCountingDown = true; // Inicia a contagem regressiva
                          _turnOnRobot(); // Liga o robô
                        }
                      });
                    }
                  : null, // Desativa o botão se o robô estiver ligado ou se estiver aguardando a temperatura baixar
              style: ElevatedButton.styleFrom(
                backgroundColor: isOperating
                    ? Colors.red
                    : Colors.green, // Altera a cor do botão com base no estado do robô
              ),
              child: Text(
                isOperating
                    ? 'Desligar Robô'
                    : 'Ligar Robô', // Altera o texto do botão com base no estado do robô
                style: TextStyle(
                  color: Colors.white, // Define a cor do texto como branco
                ),
              ),
            ),
            SizedBox(height: 20.0), // Espaçamento entre os widgets
            // Exibe a mensagem correspondente ao estado do robô e da temperatura
            Text(
              isOperating
                  ? temperature == 75
                      ? 'Robô monitorado com temperatura ideal'
                      : 'Iniciando o monitoramento'
                  : 'Robô Parado',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: isOperating && temperature == 75
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            // Exibe a mensagem de "Aguarde, desligando..." durante o desligamento do robô
            if (isCountingDown && !isOperating)
              Text(
                'Aguarde, desligando...',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Método para ligar o robô
  void _turnOnRobot() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (temperature < 75.0) {
          temperature += 15; // Aumenta a temperatura em 15 graus a cada segundo
        } else {
          isCountingDown = false; // Encerra a contagem regressiva
          timer.cancel(); // Cancela o temporizador
        }
      });
    });
  }

  // Método para desligar o robô
  void _turnOffRobot() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (temperature > 0) {
          temperature -= 15; // Diminui a temperatura em 15 graus a cada segundo
        } else {
          isOperating = false; // Define o robô como desligado
          isCountingDown = false; // Encerra a contagem regressiva
          isButtonEnabled = true; // Ativa o botão "Ligar Robô"
          timer.cancel(); // Cancela o temporizador
        }
      });
    });
  }
}