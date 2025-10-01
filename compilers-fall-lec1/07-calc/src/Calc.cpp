#include <iostream>

#include "CodeGen.h"
#include "Parser.h"
#include "Sema.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/raw_ostream.h"

static void printAST(AST *Node, int Indent = 0) {
    if (!Node) return;

    std::string Prefix(Indent, ' ');


    // 
    if (WithDecl *With = static_cast<WithDecl*>(Node)) {
        llvm::errs() << Prefix << "WithDecl (variables omitted)\n";
        if (With->getExpr()) {
            llvm::errs() << Prefix << "  expr:\n";
            printAST(With->getExpr(), Indent + 4);
        }
        return;
    }

    if (BinaryOp *BinOp = static_cast<BinaryOp*>(Node)) {
        const char *OpStr = "???";
        switch (BinOp->getOperator()) {
            case BinaryOp::Plus:  OpStr = "+"; break;
            case BinaryOp::Minus: OpStr = "-"; break;
            case BinaryOp::Mul:   OpStr = "*"; break;
            case BinaryOp::Div:   OpStr = "/"; break;
        }
        llvm::errs() << Prefix << "BinaryOp(" << OpStr << ")\n";
        if (BinOp->getLeft()) {
            llvm::errs() << Prefix << "  left:\n";
            printAST(BinOp->getLeft(), Indent + 4);
        }
        if (BinOp->getRight()) {
            llvm::errs() << Prefix << "  right:\n";
            printAST(BinOp->getRight(), Indent + 4);
        }
        return;
    }

    if (Factor *Fact = static_cast<Factor*>(Node)) {
        if (Fact->getKind() == Factor::Number) {
            llvm::errs() << Prefix << "Factor(Number: " << Fact->getVal() << ")\n";
        } else if (Fact->getKind() == Factor::Ident) {
            llvm::errs() << Prefix << "Factor(Ident: " << Fact->getVal() << ")\n";
        }
        return;
    }

    llvm::errs() << Prefix << "Unknown AST Node\n";
}

static llvm::cl::opt<std::string>
    Input(llvm::cl::Positional,
          llvm::cl::desc("<input expression>"),
          llvm::cl::init(""));

int main(int argc, const char **argv)
{
    // Init LLVM
    llvm::InitLLVM X(argc, argv);
    llvm::cl::ParseCommandLineOptions(
        argc, argv, "calc - the expression compiler\n");

    Lexer Lex(Input);

    // Dump all input tokens
    //Token token;
    //for (Lex.next(token); token.getKind() != Token::TokenKind::eoi; Lex.next(token)) {
    //    std::cout << token.getKind() << ": " << token.getText().str() << "\n";
    //}

    #if 1
    // Parse input and build abstract syntax tree
    Parser Parser(Lex);
    AST *Tree = Parser.parse();
    if (!Tree || Parser.hasError()) {
        llvm::errs() << "Syntax errors occured\n";
        return EXIT_FAILURE;
    }

    //
    // Perform symantic analysis:
    // Variable redeclaration: with a, a: 1+2
    // Undefined variable: a,b: 1 + c - d
    //


    Sema Semantic;
    if (Semantic.semantic(Tree)) {
        llvm::errs() << "Semantic errors occured\n";
        return EXIT_FAILURE;
    }

    // llvm::errs() << "=== AST ===\n";
    // printAST(Tree, 0);

    // Generate LLVM IR code
    CodeGen CodeGenerator;
    CodeGenerator.compile(Tree);
    #endif

    return EXIT_SUCCESS;
}
