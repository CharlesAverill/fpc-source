{
  $Id$

  Unit to build all units of Free Vision
}
unit buildfv;
interface
uses
  fvcommon,
  objects,
  callspec,
  drivers,
  fileio,
  memory,
  gfvgraph,

  fvconsts,
  resource,
  views,
  validate,
  msgbox,
  dialogs,
  menus,
  app,
  stddlg,

  tabs,
  statuses,
  histlist,
  inplong,
  editors,
  gadgets,
  time;

implementation

end.
{
  $Log$
  Revision 1.2  2001-08-05 02:03:13  peter
    * view redrawing and small cursor updates
    * merged some more FV extensions

  Revision 1.1  2001/08/04 19:14:32  peter
    * Added Makefiles
    * added FV specific units and objects from old FV

}
