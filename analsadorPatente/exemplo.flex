
%%

%standalone    // Habilita execução sem JCup.
%class Scanner // Nome da classe gerada.
%line          // Habilita rastreamento da linha.
%column        // Habilita rastreamento da coluna.

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder comentario = new StringBuilder();
%}

%states CONTEUDO

%%
<YYINITIAL> {
    "<B>"  { yybegin(CONTEUDO)ario.setLength(0); } 
    [^]     { /* Ignora qualquer caracter fora de comentários. */ }
}

<CONTEUDO> {
    "</B>" {
        yybegin(YYINITIAL); 
        System.out.println("Conteúdo capturado:\n" + conteudo.toString()); 
    }
    [^</B></TITLE>]+  { conteudo.append(yytext()); }  // Tudo que não é *, / ou quebra
    "</B>"     { conteudo.append('</B>'); }
    "</TITLE>" { conteudo.append('</TITLE>'); }
}

