#include "Sema.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/Support/raw_ostream.h"

namespace {

class DeclCheck : public ASTVisitor {
  llvm::StringSet<> Scope;
  bool HasError;

  enum ErrorType { Twice, Not };

  void error(ErrorType ET, llvm::StringRef V) {
    llvm::errs() << "Variable " << V << " "
                 << (ET == Twice ? "already" : "not")
                 << " declared\n";
    HasError = true;
  }

public:
  DeclCheck() : HasError(false) {}

  bool hasError() { return HasError; }

  virtual void visit(Factor &Node) override {
    if (Node.getKind() == Factor::Ident) {
      if (Scope.find(Node.getVal()) == Scope.end())
        error(Not, Node.getVal());
    }
  };

  virtual void visit(BinaryOp &Node) override {
    if (Node.getLeft())
        Node.getLeft()->accept(*this);
    else
        HasError = true;
    if (Node.getRight())
        Node.getRight()->accept(*this);
    else
        HasError = true;

    // Проверка деления на 0
    if (Node.getOperator() == BinaryOp::Div) {
        Expr *Right = Node.getRight();
        if (Right) {
            Factor *F = static_cast<Factor*>(Right);
            if (F && F->getKind() == Factor::Number) {
                double Val = std::stod(F->getVal().str());
                if (Val == 0.0) {
                    llvm::errs() << "Semantic Error: Division by zero\n";
                    HasError = true;
                }
            }
        }
    }
  };

  virtual void visit(WithDecl &Node) override {
    for (auto I = Node.begin(), E = Node.end(); I != E; ++I) {
      if (!Scope.insert(*I).second)
        error(Twice, *I);
    }
    if (Node.getExpr())
      Node.getExpr()->accept(*this);
    else
      HasError = true;
  };
};
}

bool Sema::semantic(AST *Tree) {
  if (!Tree)
    return false;
  DeclCheck Check;
  Tree->accept(Check);
  return Check.hasError();
}
