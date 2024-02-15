// Time-stamp: <28 oct 2022 09:24 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux rédacteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioRedacteur implements LectRed
{
    private ReentrantLock mon;
    private Condition lecture;
    private Condition ecriture;
    private int nbL;
    private int nbRA;
    private boolean red;



    public LectRed_PrioRedacteur() {
        this.mon = new ReentrantLock ();
        this.lecture = mon.newCondition();
        this.ecriture = mon.newCondition();
        this.red = false;
        this.nbL = 0;
        this.nbRA = 0;


    }

    public void demanderLecture() throws InterruptedException {
        mon.lock();
        while(this.red|| this.nbRA != 0){
            lecture.await();
        }
        this.nbL++;
        lecture.signal();
        mon.unlock();
        }
    

    public void terminerLecture() throws InterruptedException {
        mon.lock();
        this.nbL --;
        if (this.nbL == 0){
            ecriture.signal();
        }
        mon.unlock();
    }

    public void demanderEcriture() throws InterruptedException {
        mon.lock();
        while (this.red || this.nbL > 0){
            this.nbRA ++;
            ecriture.await();
            this.nbRA --;
        }
        this.red = true;
       
        mon.unlock();
    }

    public void terminerEcriture() throws InterruptedException {
        mon.lock();
        this.red = false;
        this.ecriture.signal();
        if (this.red == false && this.nbRA == 0){
            this.lecture.signal();
        }
        mon.unlock();
    }

    public String nomStrategie() {
        return "Stratégie: Priorité Rédacteurs.";
    }
}