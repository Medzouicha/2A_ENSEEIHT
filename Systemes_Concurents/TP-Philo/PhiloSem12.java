// Time-stamp: <08 déc 2009 08:30 queinnec@enseeiht.fr>

import java.util.concurrent.Semaphore;

public class PhiloSem12 implements StrategiePhilo {

    private static Semaphore[] fourchettes;

    public PhiloSem12 (int nbPhilosophes) {
        this.fourchettes = new Semaphore[nbPhilosophes];
        for (int k = 0; k < nbPhilosophes; k++)
            this.fourchettes[k] = new Semaphore(1);
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException{
        boolean eat = false;
        while (!eat) {
            this.fourchettes[Main.FourchetteDroite(no)].acquire();
            IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.AssietteGauche);
            if (this.fourchettes[Main.FourchetteGauche(no)].tryAcquire()) {
                IHMPhilo.poser(Main.FourchetteGauche(no), EtatFourchette.AssietteDroite);
                eat = true;
            } else {
                this.fourchettes[Main.FourchetteDroite(no)].release();
                IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.Table);    
            }
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
        return "Implantation Sémaphores, stratégie de base(Solution 2)";
    }

}