// Time-stamp: <28 oct 2022 09:24 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux rédacteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioLecteur implements LectRed
{
    private ReentrantLock mon;
    private Condition lecture;
    private Condition ecriture;
    private int nbL;
    private int nbLA;
    private boolean red;



    public LectRed_PrioLecteur() {
        this.mon = new ReentrantLock ();
        this.lecture = mon.newCondition();
        this.ecriture = mon.newCondition();
        this.red = false;
        this.nbL = 0;
        this.nbLA = 0;
        


    }

    public void demanderLecture() throws InterruptedException {
        this.mon.lock();
        while(this.red){
            this.nbLA ++;
            this.lecture.await();
            this.nbLA --;
        }
        this.nbL++;
        this.lecture.signal();
        this.mon.unlock();
        }
    

    public void terminerLecture() throws InterruptedException {
        mon.lock();
        this.nbL --;
        this.lecture.signal();
        if (this.nbL == 0 || this.nbLA == 0 ){
            this.ecriture.signal();
        }
        mon.unlock();
    }

    public void demanderEcriture() throws InterruptedException {
        mon.lock();
        while (this.red || this.nbL > 0 || this.nbLA > 0){
            
            this.ecriture.await();

        }
        this.red = true;
        this.ecriture.signal();
       
        mon.unlock();
    }

    public void terminerEcriture() throws InterruptedException {
        mon.lock();
        this.red = false;

        this.lecture.signal();
        mon.unlock();
    }

    public String nomStrategie() {
        return "Stratégie: Priorité Rédacteurs.";
    }
}