%%

%class PatentLexer
%unicode
%line
%column
%cup
%public

%{
    String number = "";
    String date = "";
    String title = "";
    String abstractText = "";
    String claims = "";
%}

%state TITLE, ABSTRACT, CLAIMS

%%

<YYINITIAL> {
    // Número da patente
    "<B>" [0-9]{1,3}(,[0-9]{3})* "</B>" {
        number = yytext().replaceAll("<.*?>", "").trim();
    }

    // Data de publicação (aparece alinhado à direita com <B>)
    "<B>" [A-Z][a-z]+ [0-9]{1,2}, [0-9]{4} "</B>" {
        date = yytext().replaceAll("<.*?>", "").trim();
    }

    // Título principal (font size +1)
    "<font size=\"\\+1\">" {
        yybegin(TITLE);
    }

    // Início do abstract
    "<CENTER><B>Abstract</B></CENTER>" {
        yybegin(ABSTRACT);
    }

    // Início da seção de claims
    "<CENTER><B><I>Claims</B></I></CENTER>" {
        yybegin(CLAIMS);
    }
}

// Extração do título
<TITLE> {
    [^<]+ {
        title += yytext().trim() + " ";
    }
    "</font>" {
        yybegin(YYINITIAL);
    }
}

// Extração do abstract
<ABSTRACT> {
    "<P>" |
    "<BR>" |
    "<BR><BR>" { /* ignora */ }

    "</P>" {
        yybegin(YYINITIAL);
    }

    [^<]+ {
        abstractText += yytext().trim() + " ";
    }
}

// Extração das claims
<CLAIMS> {
    "<BR>" |
    "<BR><BR>" |
    "<HR>" { /* ignora */ }

    // Fim das claims ao encontrar nova seção
    "<CENTER><B>" {
        yybegin(YYINITIAL);
    }

    "</HTML>" {
        yybegin(YYINITIAL);
    }

    [^<]+ {
        claims += yytext().trim() + " ";
    }
}

<<EOF>> {
    System.out.println("Número: " + number);
    System.out.println("Data: " + date);
    System.out.println("Título: " + title.trim());
    System.out.println("Resumo: " + abstractText.trim());
    System.out.println("Reivindicações: " + claims.trim());
    return null;
}
