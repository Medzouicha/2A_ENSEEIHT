// Time-stamp: <08 déc 2009 08:30 queinnec@enseeiht.fr>

import java.util.concurrent.Semaphore;

public class PhiloSem11 implements StrategiePhilo {

    private static Semaphore[] fourchettes;

    /** Constructeur de classe */
    public PhiloSem11 (int nbPhilosophes) {
        this.fourchettes = new Semaphore[nbPhilosophes];
        for (int k = 0; k < nbPhilosophes; k++)
            this.fourchettes[k] = new Semaphore(1);
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException{
        if (no == 0) {
            this.fourchettes[Main.FourchetteDroite(no)].acquire();
            IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.AssietteGauche);
            this.fourchettes[Main.FourchetteGauche(no)].acquire();
            IHMPhilo.poser(Main.FourchetteGauche(no), EtatFourchette.AssietteDroite);
        } else {
            this.fourchettes[Main.FourchetteGauche(no)].acquire();
            IHMPhilo.poser(Main.FourchetteGauche(no), EtatFourchette.AssietteDroite);
            this.fourchettes[Main.FourchetteDroite(no)].acquire();
            IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.AssietteGauche);
        }
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. */
    public void libererFourchettes (int no)
    {
        int fd = Main.FourchetteDroite(no);
    	int fg = Main.FourchetteGauche(no);
        this.fourchettes[fd].release();
    	IHMPhilo.poser(fd, EtatFourchette.Table);
        this.fourchettes[fg].release();
    	IHMPhilo.poser(fg, EtatFourchette.Table);
 
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, stratégie de Base (Solution 1)";
    }

}