The ``longarrows`` package
==========================

This package fixes an issue that appears when long double arrows
(``\Longleftarrow`` and ``\Longrightarrow``) are typeset with a size of 12 pt or
more.  These characters are created by superimposing an equals sign over a short
double arrow (``\Leftarrow`` and ``\Rightarrow``).  Because the equals sign and
the arrows come from different fonts that are available in different optical
sizes, the two glyphs don’t match if the font size is larger than 11 pt.
