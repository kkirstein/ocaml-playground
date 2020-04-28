(* vim: set ft=ocaml sw=2 ts=2: *)

(*
 * scene.ml
 *
 * Objects describing a scene of charts, graphs, and its contents.
 * Taken from The Grammar of Graphics by Leland Wilkinson
 * (https://www.springer.com/in/book/9780387245447)
 *)

class label =
  object (_self)
  end


class symbol =
  object (_self)
  end


class curve =
  object (_self)
  end


class graph =
  object (_self)
  end


class contour =
  object (_self)
    inherit graph
    val contour = new curve
  end


class point =
  object (_self)
    inherit graph
    val symbol = new symbol
    val label = new label
  end


class scale =
  object (_self)
  end


class rule =
  object (_self)
  end


class line =
  object (_self)
  end


class guide =
  object (_self)
  end


class axis =
  object (_self)
    inherit guide
    val scale = new scale
    val rule = new rule
    val label = new label
  end


class form =
  object (_self)
    inherit guide
    val line = new line
    val label = new label
  end


class frame =
  object (_self)
  end


class chart =
  object (_self)
    val mutable guides = ([] : guide list)
    val mutable frame = new frame
    val mutable graphs = ([] : graph list)
  end

