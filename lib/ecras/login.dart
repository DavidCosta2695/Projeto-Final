  import 'package:flutter/material.dart';
  import '../servicos/auth_servico.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  class LoginPage extends StatefulWidget {
    const LoginPage({super.key});
  
    @override
    State<LoginPage> createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final AuthService _authService = AuthService();
    
    bool _isLoading = false;

    
    void _mostrarAviso(String mensagem) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
    }

    
void _loginComEmail() async {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        _mostrarAviso('Preenche o email e a password.');
        return;
      }

      setState(() => _isLoading = true);

      try {
        await _authService.loginComEmail(
          _emailController.text.trim(), 
          _passwordController.text.trim()
        );
        
        
        User? utilizador = FirebaseAuth.instance.currentUser;
        
        if (utilizador != null && !utilizador.emailVerified) {
          
          await _authService.logout(); 
          _mostrarAviso('Por favor, verifica a tua caixa de email (e o spam) para ativar a conta!');
          setState(() => _isLoading = false);
          return; 
        }
        

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        _mostrarAviso('Erro ao entrar: Verifica os teus dados.');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    void _criarConta() async {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        _mostrarAviso('Preenche o email e a password para criar conta.');
        return;
      }

      setState(() => _isLoading = true);

      try {
        await _authService.registarComEmail(
          _emailController.text.trim(), 
          _passwordController.text.trim()
        );
        

        await _authService.logout();
        
        _mostrarAviso('Conta criada! Enviámos um link de confirmação para o teu email.');
        
        
        _passwordController.clear();
        
        
      } catch (e) {
        _mostrarAviso('Erro ao criar conta: Pode já existir ou a password ser fraca.');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
    
    void _loginComGoogle() async {
      setState(() => _isLoading = true);

      try {
        final user = await _authService.loginWithGoogle();
        if (!mounted) return;
        
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        _mostrarAviso('Erro no login com o Google: $e');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Image.asset('lib/images/predimed_logo.png', height: 120,),
                const SizedBox(height: 16),
                const SizedBox(height: 40),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true, 
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                
                if (_isLoading)
                  const CircularProgressIndicator()
                else ...[
                
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loginComEmail,
                      child: const Text('Iniciar Sessão'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _criarConta,
                      child: const Text('Criar Conta'),
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Text('OU', style: TextStyle(color: Colors.grey)),
                  ),

                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 17, 16, 16),
                      ),
                      icon: const Icon(Icons.g_mobiledata, size: 32),
                      label: const Text('Usar o Google'),
                      onPressed: _loginComGoogle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }
  }