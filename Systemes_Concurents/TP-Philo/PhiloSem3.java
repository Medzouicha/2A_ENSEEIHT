// Time-stamp: <08 déc 2009 08:30 queinnec@enseeiht.fr>

import java.util.concurrent.Semaphore;

public class PhiloSem3 implements StrategiePhilo {

    /****************************************************************/
    private Semaphore[] philosophes;
    private Semaphore mutex;
    private int[] tempsPhilosophes;
    private EtatPhilosophe[] philosophesEtats;

    public PhiloSem3 (int nbPhilosophes) {
        this.mutex = new Semaphore(1);
        this.philosophes = new Semaphore[nbPhilosophes];
        this.philosophesEtats = new EtatPhilosophe[nbPhilosophes];
        this.tempsPhilosophes = new int[nbPhilosophes];
        for (int k = 0; k < nbPhilosophes; k++) {
            this.philosophes[k] = new Semaphore(0);
            this.philosophesEtats[k] = EtatPhilosophe.Pense;
            this.tempsPhilosophes[k] = 0;
        }
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException
    {
        boolean eat = false;   
        while (!eat) {
            this.mutex.acquire();
            int pg = Main.PhiloGauche(no);
    	    int pd = Main.PhiloDroite(no);
            this.philosophesEtats[no] = EtatPhilosophe.Demande;
            if (this.philosophesEtats[pd] != EtatPhilosophe.Mange && this.philosophesEtats[pg] != EtatPhilosophe.Mange) {
                IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.AssietteGauche);
                IHMPhilo.poser(Main.FourchetteGauche(no), EtatFourchette.AssietteDroite);
                this.tempsPhilosophes[no] = 0;
                this.philosophesEtats[no] = EtatPhilosophe.Mange;
                this.mutex.release();
                eat = true;
            } else {
                this.mutex.release();
                this.tempsPhilosophes[no]++;
                this.philosophesEtats[no] = EtatPhilosophe.Demande;
                this.philosophes[no].acquire();
            }
            
        }
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. */
    public void libererFourchettes (int no) throws InterruptedException
    {
        this.mutex.acquire();
        IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.Table);
        IHMPhilo.poser(Main.FourchetteGauche(no), EtatFourchette.Table);
        this.philosophesEtats[no] = EtatPhilosophe.Pense;       
        if (this.philosophesEtats[Main.PhiloGauche(no)] == EtatPhilosophe.Demande && this.philosophesEtats[Main.PhiloDroite(Main.PhiloGauche(no))] != EtatPhilosophe.Mange && this.philosophesEtats[Main.PhiloGauche(Main.PhiloGauche(no))] != EtatPhilosophe.Mange) {
            if (tempsPhilosophes[Main.PhiloGauche(no)] < tempsPhilosophes[Main.PhiloDroite(no)]){
                        this.philosophes[Main.PhiloGauche(no)].release();

            }

        }      
        if (this.philosophesEtats[Main.PhiloDroite(no)] == EtatPhilosophe.Demande && this.philosophesEtats[Main.PhiloDroite(Main.PhiloDroite(no))] != EtatPhilosophe.Mange && this.philosophesEtats[Main.PhiloGauche(Main.PhiloDroite(no))] != EtatPhilosophe.Mange) {
            this.philosophes[Main.PhiloDroite(no)].release();
        }
        this.mutex.release();
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, stratégie d'etats";
    }

}

