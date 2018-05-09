/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar plc14tp2_isac;

@header{ import java.util.*; 
         import java.io.*;
       }
@members{ int proxAdress = 0;
          int i;
          int Endr;
          PrintWriter fich;
          Nivel nCicl = new Nivel();
          Nivel nCond = new Nivel();
         
         public enum Codigo
{
    Verdadeiro, Falso, Soma, Sub, Ou, E, Vezes, Dividir, Menor, Maior, MenorIgual,
    MaiorIgual, Igual, Diferente, Inteiro, Array, Vazio
}

public class Dado
{   
    public Dado(Codigo tipo, int endereco, int quantidade, String nome){
        this.tipo = tipo;
        this.endereco = endereco;
        this.quantidade = quantidade;
        this.nome = nome;
    }
    
    public Dado(Dado d){
        this.tipo = d.getTipo();
        this.endereco = d.getEndereco();
        this.quantidade = d.getQuantidade();
        this.nome = d.getNome();
    }
    
    private Codigo tipo;
    private int endereco;
    private int quantidade;
    private String nome;
    
    public Codigo getTipo(){
        return this.tipo;
    }
    
    public int getEndereco(){
        return this.endereco;
    }
    
    public int getQuantidade(){
        return this.quantidade;
    }
    
    public String getNome(){
        return this.nome;
    }
    
    public void setTipo(Codigo tipo){
        this.tipo = tipo;
    }
    
    public void setEndereco(int endereco){
        this.endereco = endereco;
    }
    
    public void setQuantidade(int quantidade){
        this.quantidade = quantidade;
    }
    
    public void setNome(String nome){
        this.nome = nome;
    }
    
    public boolean equals(Object obj){
        if(this == obj)
            return true;
        
        if(obj == null || this.getClass() != obj.getClass())
            return false;
            
        Dado d = (Dado) obj;
        
        return(this.tipo== d.getTipo() && this.endereco == d.getEndereco() &&
               this.quantidade == d.getQuantidade() && this.nome.equals(d.getNome()));
    }
    
    public Dado clone(){
        return new Dado(this);
    }
    
    public String toString(){
        StringBuffer b = new StringBuffer();
        b.append("O nome é " + this.nome + "\n");
        b.append("O tipo é " + this.tipo.name() + "\n");
        b.append("A quantidade é " + this.quantidade + "\n");
        b.append("O endereço é " + this.endereco + "\n");
        
        return b.toString();
    }
}

public class Tabela_Dados
{
    private HashMap<String, Dado> dcs;

    public Tabela_Dados(){
        this.dcs = new HashMap<String, Dado>();
    }
    
    public Tabela_Dados(HashMap<String, Dado> dcs){
        dcs = new HashMap<String, Dado>();
        
        for(Dado d : dcs.values()){
            this.dcs.put(d.getNome(), d.clone());
        }

    }
    
    public Tabela_Dados(Tabela_Dados tb){
        this.dcs = new HashMap<String, Dado>();
        
        for(Dado d : (tb.getDcs()).values()){
            this.dcs.put(d.getNome(), d.clone());
        }
    }
    
    public HashMap<String, Dado> getDcs(){
        HashMap<String, Dado> aux = new HashMap<String, Dado>();
        
        for(Dado d : this.dcs.values()){
            aux.put(d.getNome(), d.clone());
        }
        
        return aux;
    }
    
    public void setDcs(HashMap<String, Dado> dcs){
        this.dcs = new HashMap<String, Dado>();
        
        for(Dado d : this.dcs.values()){
            this.dcs.put(d.getNome(), d.clone());
        }
    }
    
    public void insereDado(Dado d)throws ExistDadoException{
        if(this.dcs.containsKey(d.getNome()))
            throw new ExistDadoException("A variavel " + d.getNome() + " já foi declarada anteriormente!");
        
        else
            this.dcs.put(d.getNome(), d.clone());
        
    }
    
    public void eliminaDado(Dado d)throws NoExistDadoException{
        if(!this.dcs.containsKey(d.getNome()))
            throw new NoExistDadoException("A variavel " + d.getNome() + " não foi declarada!");
         
        else
            this.dcs.remove(d.getNome());
        
    }
    
    public boolean existeDado(Dado d){
        if(this.dcs.containsKey(d.getNome()))
            return true;
        else
            return false;
    }
    
    public boolean existeChave(String chave){
        if(this.dcs.containsKey(chave))
            return true;
        else
            return false;
    }
    
    public int getEndereco(String cod)throws NoExistDadoException{
        if(this.dcs.containsKey(cod)){
            Dado d = this.dcs.get(cod);
            return d.getEndereco();
        }
        else
            throw new NoExistDadoException("A variavel " + cod + " está a ser usada sem ter sido declarada!");
    }
    
    public boolean equals(Object obj){
        if(obj == this)
            return true;
        if(obj == null || obj.getClass() != this.getClass())
            return false;
            
        Tabela_Dados tb = (Tabela_Dados) obj;
        
        return(this.dcs.equals(tb.getDcs()));
    }
    
    public Tabela_Dados clone(){
        return new Tabela_Dados(this);
    }
    
    public String toString(){
        StringBuffer b = new StringBuffer();
        
        for(Dado d : this.dcs.values()){
            b.append("Chave: " + d.getNome());
            b.append("Valor: " + d.toString());
        }
        
        return b.toString();
    }
}

public class ExistDadoException extends Exception
{
    ExistDadoException(){
        super();
    }
    
    ExistDadoException(String e){
        super(e);
    }
}

public class NoExistDadoException extends Exception
{
    public NoExistDadoException(){
        super();
    }
    
    public NoExistDadoException(String e){
        super(e);
    }
}

public class Nivel
{
    // variáveis de instância - substitua o exemplo abaixo pelo seu próprio
    private Stack<Integer> stk;
    private Integer i;
    
    public Nivel(){
        this.stk = new Stack<Integer>();
        this.i = new Integer(1);
    }
    
    public Nivel(Stack<Integer> stk, Integer i){
        this.stk = new Stack<Integer>();
        for(Integer j : stk)
            this.stk.push(j);
        this.i = new Integer(i.intValue());
    }
    
    public Nivel(Nivel n){
        this.stk = new Stack<Integer>();
        for(Integer i : n.getStk())
            this.stk.push(i);
            
        this.i = n.getI();
    }
    
    public Stack<Integer> getStk(){
        Stack<Integer> aux = new Stack<Integer>();
        for(Integer i : this.stk)
            aux.push(i);
        return aux;
    }
    
    public Integer getI(){
        return this.i;
    }
    
    public void setStk(Stack<Integer> stk){
        this.stk = new Stack<Integer>();
        for(Integer i : stk)
            this.stk.push(i);
    }
    
    public void setI(Integer i){
        this.i = new Integer(i.intValue());
    }
    
    public void incNivel(){
        this.stk.push(this.i);
        this.i++;
    }
    
    public void decNivel(){
        this.stk.pop();
    }
    
    public int topNivel(){
        return this.stk.peek();
    }
    
    public Nivel clone(){
        return new Nivel(this);
    }
    
    public boolean equals(Object obj){
        if(this == obj)
            return true;
        if(obj == null || this.getClass() != obj.getClass())
            return false;
            
        Nivel n = (Nivel) obj;
        
        return(this.stk.equals(n.getStk()));
    }
    
    public String toString(){
        StringBuffer s = new StringBuffer();
        for(Integer i : this.stk)
            s.append("1º número " + i);
        return s.toString();
    }
}

}

lingImp     :  'BEGIN' {    try{
                                fich = new PrintWriter(new FileWriter("Desktop/tplc/LingImp.asm"));
                            }
                            catch(IOException e){
                                System.out.println(e.getMessage());
                                System.exit(1);
                            }
                        }
                        decls    {   fich.println("START");} statments[$decls.dcs] 'END'   { fich.println("STOP");   fich.flush(); fich.close(); }
            ;
decls   returns[Tabela_Dados dcs]
@init{$decls.dcs = new Tabela_Dados();}
            :  ( decl { try{
                           $decls.dcs.insereDado($decl.d);
                        }
                        catch(ExistDadoException e){
                           System.out.println(e.getMessage());
                           System.exit(1);
                        }
                      } 
               )* 
            ;
statments[Tabela_Dados dcs]
            : ( statment[$statments.dcs] )*
            ;
statment[Tabela_Dados dcs]
            :  atrib[$statment.dcs]
            |  ciclo[$statment.dcs]
            |  condicional[$statment.dcs]
            |  output[$statment.dcs]
            |  input[$statment.dcs]
            ;
atrib[Tabela_Dados dcs]
            :  nome '=' exp[$atrib.dcs] ';' { try{
                                                    Endr = $atrib.dcs.getEndereco($nome.name);
                                                    fich.println("STOREG " + Endr);
                                              }
                                              catch(NoExistDadoException e){
                                                    System.out.println(e.getMessage());
                                                    System.exit(1);
                                              }
                                             }
            | nome '['{ try{
                            Endr = $atrib.dcs.getEndereco($nome.name);
                            fich.println("PUSHGP");
                            fich.println("PUSHI " + Endr);
                            fich.println("PADD");
                        }
                        catch(NoExistDadoException e){
                           System.out.println(e.getMessage());
                           System.exit(1);
                        }
                            
                        }
                        e1=exp[$atrib.dcs] ']' '=' e2=exp[$atrib.dcs] ';' {fich.println("STOREN");}
            ;
exp[Tabela_Dados dcs]
            :  termo[$exp.dcs] ( opad termo[$exp.dcs]{ i = $opad.cod.ordinal();
                                                       switch(i){
                                                          case 2:
                                                            fich.println("ADD");
                                                            break;
                                                          case 3:
                                                            fich.println("SUB");
                                                            break;
                                                          case 4:
                                                            fich.println("OR");
                                                            break;
                                                          default:
                                                            System.out.println("Operador errado!");
                                                            System.exit(1);
                                                            break;
                                                       }
                                                      
                                                     }
                               )*
            ;
termo[Tabela_Dados dcs]
            :  factor[$termo.dcs] ( opmul factor[$termo.dcs]    {   i = $opmul.cod.ordinal();
                                                                    switch(i){
                                                                        case 5:
                                                                            fich.println("AND");
                                                                             break;
                                                                        case 6:
                                                                            fich.println("MUL");
                                                                            break;
                                                                        case 7:
                                                                            fich.println("DIV");
                                                                             break;
                                                                        default:
                                                                            System.out.println("Operador errado!");
                                                                            System.exit(1);
                                                                            break;
                                                                    }
                                                                  }   
                                  )*
            ;
factor[Tabela_Dados dcs]
            :  NUM  {fich.println("PUSHI " + $NUM.int );}
            |  bool {fich.println($bool.v);}
            |  nome {   try{
                             Endr = $factor.dcs.getEndereco($nome.name);
                             fich.println("PUSHG " + Endr);
                         }
                         catch(NoExistDadoException e){
                            System.out.println(e.getMessage());
                            System.exit(1);
                         }
                    }
            | nome '['{ try{
                           Endr = $factor.dcs.getEndereco($nome.name);
                           fich.println("PUSHGP");
                           fich.println("PUSHI " + Endr);
                           fich.println("PADD");
                        }
                        catch(NoExistDadoException e){
                           System.out.println(e.getMessage());
                           System.exit(1);
                        }
                      }
                      exp[$factor.dcs] ']'{ fich.println("LOADN");}
            ;
opad returns[ Codigo cod]
            :  '+'  {$opad.cod = Codigo.Soma;}
            |  '-'  {$opad.cod = Codigo.Sub;}
            |  '||' {$opad.cod = Codigo.Ou;}
            ;
opmul returns [Codigo cod]
            :  '*'  {$opmul.cod = Codigo.Vezes;}
            |  '/'  {$opmul.cod = Codigo.Dividir;}
            | '&&' {$opmul.cod = Codigo.E;}
            ;
nome returns [String name]
            :  n1=PAL { $nome.name = $n1.text;}
            ;
ciclo[Tabela_Dados dcs]
            :  'WHILE' '('{nCicl.incNivel(); fich.println("ciclo" + nCicl.topNivel() + ": NOP");} condicao[$ciclo.dcs] ')' {fich.println("JZ fciclo" + nCicl.topNivel());} '{' statments[$ciclo.dcs]'}'{fich.println("JUMP ciclo" + nCicl.topNivel()); fich.println("fciclo" + nCicl.topNivel() +": NOP"); nCicl.decNivel();}
            ;
condicao[Tabela_Dados dcs]
            :  exp[$condicao.dcs] ( simb exp[$condicao.dcs] { //alterar
                                                             i = $simb.cod.ordinal();
                                                              switch(i){
                                                                case 4:
                                                                    fich.println("OR");
                                                                    break;
                                                                case 5:
                                                                    fich.println("AND");
                                                                    break;
                                                                case 8:
                                                                    fich.println("INF");
                                                                     break;
                                                                case 9:
                                                                    fich.println("SUP");
                                                                     break;
                                                                case 10:
                                                                    fich.println("INFEQ");
                                                                     break;
                                                                case 11:
                                                                    fich.println("SUPEQ");
                                                                     break;
                                                                case 12:
                                                                    fich.println("EQUAL");
                                                                    fich.println("NOT");
                                                                     break;
                                                                case 13:
                                                                    fich.println("EQUAL");
                                                                     break;
                                                                default:
                                                                    System.out.println("Operador errado!");
                                                                    System.exit(1);
                                                                    break;
                                                               }
                                                             }
                                  ) *
            ;
bool  returns[int v]
            :  'TRUE'   {   $bool.v = 1;}
            |  'FALSE'  {   $bool.v = 0;}
            ;
simb    returns[Codigo cod]
            :  '<'  {$simb.cod = Codigo.Menor;}
            |  '>'  {$simb.cod = Codigo.Maior;}
            |  '>=' {$simb.cod = Codigo.MaiorIgual;}
            |  '<=' {$simb.cod = Codigo.MenorIgual;}
            |  '&&' {$simb.cod = Codigo.E;}
            |  '||' {$simb.cod = Codigo.Ou;}
            |  '==' {$simb.cod = Codigo.Igual;}
            |  '!=' {$simb.cod = Codigo.Diferente;}
            ;
condicional[Tabela_Dados dcs]
            :  'IF' '(' condicao[$condicional.dcs] ')'{nCond.incNivel(); fich.println("JZ senao" + nCond.topNivel());} 'THEN' '{' statments[$condicional.dcs] '}'{fich.println("JUMP fse" + nCond.topNivel()); 
                                                                                                                                  fich.println("senao" + nCond.topNivel() +": NOP");} senao[$condicional.dcs] { nCond.decNivel();}
            ;
senao[Tabela_Dados dcs]
            :
            |  'ELSE' '{' statments[$senao.dcs] '}'{fich.println("fse" + nCond.topNivel() + ": NOP");}
            ;
decl returns[Dado d]
            : 'INT' nome ';' {  $decl.d = new Dado(Codigo.Inteiro, proxAdress++, 1, $nome.name); fich.println("PUSHI 0");} 
            | 'INT' nome '[' n3 = NUM ']' ';'  {    $decl.d = new Dado(Codigo.Array, proxAdress, $n3.int, $nome.name); proxAdress+=$n3.int; fich.println("PUSHN " + $n3.int);} 
            ;
output[Tabela_Dados dcs]
            : 'PRINT' '(' TEXTO ',' exp[$output.dcs] ')' ';'{ fich.println("PUSHS " + $TEXTO.text); fich.println("WRITES"); fich.println("WRITEI"); }
            ;
input[Tabela_Dados dcs]
            :   'SCAN' '(' nome ')' ';'{    try{
                                                Endr = $input.dcs.getEndereco($nome.name);
                                                fich.println("READ");
                                                fich.println("ATOI");
                                                fich.println("STOREG " + Endr);
                                                }
                                            catch(NoExistDadoException e){
                                                 System.out.println(e.getMessage());
                                                 System.exit(1);
                                            }
                                        }
            ;

                           
TEXTO   :   '"' ~('"')* '"';                
PAL  : (('a'..'z')|('A'..'Z'))+ ;
NUM  : [0-9]+;
WS   : ('\r'?'\n' | ' ' | '\t')+ -> skip;
                           
