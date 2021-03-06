
import math
import matplotlib.pyplot as plt
import matplotlib.patches as patches

def plot_keyboard(mapping, columns):
    """
    Plots the keyboard
    mapping: dict from letters to keynumber
    columns: the number of columns of the keyboard
    """
    
    rows = int(math.ceil(len(mapping)/float(columns)))

    fig,ax = plt.subplots(1)
    fig.set_size_inches(3,3)

    #box dimensions
    key_height = 4
    key_width = 4

    #keyboard specifics
    row_distance = 0.5
    column_distance = 0.5

    for row in range(0,rows):
        for column in range(0,columns):
            x = (column*key_width)+column*column_distance
            y = (row*key_height) + row*row_distance
        
            #print button
            ax.add_patch(
                patches.Rectangle((x,y), key_width, key_height, fill=False))
            
    for l,slot in mapping.items():
        row = slot // columns
        column = slot % columns

        x = (column*key_width)+(column*column_distance) + key_width/float(2)
        y = (row*key_height) + (row*row_distance) + key_height/float(2) 
        
        #print label
        l=l.capitalize()
        ax.text(x,y,l, horizontalalignment='center', verticalalignment='center', fontsize=18, color='k')
        
        
    max_x = (columns-1)*key_width+(columns-1)*column_distance +key_width + 1
    max_y = (rows-1)*key_height + (rows-1)*row_distance + key_height + 1
    
    plt.axis('off')
    ax.set_xlim([-1,max(max_x, max_y)])
    ax.set_ylim([-1,max(max_x, max_y)])
    
    
'''
   Plots a lattice layout in SVG format

   Original from : http://nbviewer.jupyter.org/gist/rpmuller/5666810
   Modified by Antti Oulasvirta, April 2017
'''

import math
import matplotlib.pyplot as plt
import matplotlib.patches as patches

class SVGlayout:
    def __init__(self, labels, columns, padding = 5, associations = None):
        self.labels = labels
        self.columns = columns
        self.w = 100 # element width
        self.h = 70  # element height
        self.p = padding # padding
        self.border = 0
        if associations == None:
            self.colors = ['white'] * len(labels)
        else:
            self.colorize(associations)
        self.polygons = self.topolygons()
        self.inSVG = self.tosvg()

    def topolygons(self):

       """
       Converts a list of color assignments into polygons describing a lattice layout.
       Columns is the number of columns in the layout.
       Colors is the assignment of colors to cells in the lattice.
       """

       polygons = []


       for i,color in enumerate(self.colors):
           column = int(i / self.columns)
           row = i % self.columns
           w = self.w
           h = self.h
           p = self.p
           polygons.append([(row*w+p*(row+1),column*h+p*(column+1)),(row*w+w+p*(row+1),column*h+p*(column+1)),(row*w+w+p*(row+1),column*h+h+p*(column+1)),(row*w+p*(row+1),column*h+h+p*(column+1))])

           #[(-20,0),(0,100),(5,100),(5,0)]
       return polygons
       #colorindex = ['aqua','blue','fuchsia','gray','green','lime','maroon',
       #              'navy','olive','purple','red','silver','teal','yellow']

    def tosvg(self):
       """
       Convert a list of polygons and their colors into an SVG image.
       Polygons are lists of x,y tuples.
       Colors is a list of color names (e.g., 'aqua')
       """
       import xml.etree.ElementTree as ET

       xmin,xmax,ymin,ymax = self.bbox()
       width = xmax + self.p * 2
       height = ymax + self.p * 2

       # insert bounding box as a polygon
       svg = ET.Element('svg', xmlns="http://www.w3.org/2000/svg", version="1.1",
                       height="%s" % height, width="%s" % width)
       canvas = [(0,0),(xmax+self.p,0),(xmax+self.p,ymax+self.p),(0,ymax+self.p)]
       self.polygons.insert(0,canvas)
       self.colors.insert(0,"white")
       self.labels.insert(0, "")

       # add each element to ET
       for i,polygon in enumerate(self.polygons):
           point_list = " ".join(["%d,%d" % (x,y) for (x,y) in polygon])
           ET.SubElement(svg,"polygon",fill=self.colors[i],
                         stroke="black",points=point_list)

       # add labels
       e_h = int( (self.polygons[i][2][1] - self.polygons[i][0][1]) / 1.5) # positioning in a rectangle

       for i,label in enumerate(self.labels):
           e_w = int( (self.polygons[i][1][0] - self.polygons[i][0][0]) / (2 + len(label) / 1.15))

           el = ET.SubElement(svg,"text",x=str(self.polygons[i][0][0] + e_w),y=str(self.polygons[i][0][1] + e_h))
           el.set("font-size",str(25))
           el.text = label
       return ET.tostring(svg)

    def bbox(self):
       """
       Compute the bounding box of a list of polygons. Border adds an optional
       border amount to all values in the bbox.
       """
       xmin=ymin = 1e10
       xmax=ymax = -1e10
       for polygon in self.polygons:
           for x,y in polygon:
               xmax = max(xmax,x)
               xmin = min(xmin,x)
               ymax = max(ymax,y)
               ymin = min(ymin,y)
       return xmin-self.border,xmax+self.border,ymin-self.border,ymax+self.border