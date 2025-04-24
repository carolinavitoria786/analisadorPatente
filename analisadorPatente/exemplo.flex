
import patente/Patente.java

%%

%standalone    // Habilita execução sem JCup.
%class Scanner // Nome da classe gerada.
%line          // Habilita rastreamento da linha.
%column        // Habilita rastreamento da coluna.

%{
    Patente patente = new Patente();

    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder conteudo = new StringBuilder();
%}

inicioTitulo = "</b></td>
</tr>
</tbody></table>
<hr>
<font size="+1">"

fimTitulo = "</font><br>"

%states CONTEUDO

%%
<YYINITIAL> {
    {inicioTitulo}][.]{fimTitulo} { patente.lerTitulo(yytext); }
    "<B>"  { yybegin(CONTEUDO); conteudo.setLength(0); } 
    [^]     { /* Ignora qualquer caracter fora de comentários. */ }
}

<CONTEUDO> {
    "</B>" {
        yybegin(YYINITIAL); 
        System.out.println("Conteúdo capturado:\n" + conteudo.toString()); 
    }
    [^</B> </TITLE>]+  { conteudo.append(yytext()); }  // Tudo que não é *, / ou quebra

}

